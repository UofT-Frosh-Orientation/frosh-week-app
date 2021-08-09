import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import 'package:frosh_week_2t1/src/pages/login_page.dart';
import 'src/pages/home_page.dart';
import 'src/pages/notifications_page.dart';
import 'src/pages/resources_page.dart';
import 'src/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  print(appDocPath);
  Dio dio = Dio();
  var cookieJar = PersistCookieJar(ignoreExpires: true, storage: FileStorage(appDocPath + './cookies'));
  // dio.interceptors.add(CookieManager(cookieJar));
  runApp(App(preferences: preferences, dio: dio));
}

class App extends StatefulWidget {
  final SharedPreferences preferences;
  final Dio dio;
  const App({
    Key? key,
    required this.preferences,
    required this.dio,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //TODO: add an error page
          print("There was an error");
          return MyApp(preferences: widget.preferences, dio: widget.dio);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp(preferences: widget.preferences, dio: widget.dio);
        }

        //TODO: add a loading page
        return MyApp(preferences: widget.preferences, dio: widget.dio);
      },
    );
  }
}


class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  final Dio dio;

  const MyApp({
    Key? key,
    required this.preferences,
    required this.dio
  }) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'F!rosh Week',
      theme: ThemeData(
        fontFamily: 'Avenir',
        buttonColor: Theme.of(context).colorScheme.lightPurpleAccent,
        primaryColor: Colors.white,
        accentColor: Theme.of(context).colorScheme.lightPurpleAccent,
        primaryColorDark: Colors.grey[200],
        primaryColorLight: Colors.grey[100],
        primaryColorBrightness: Brightness.light,
        brightness: Brightness.light,
        canvasColor: Colors.grey[100],
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        cupertinoOverrideTheme:
            const CupertinoThemeData(brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
          fontFamily: 'Avenir',
          buttonColor: Theme.of(context).colorScheme.lightPurpleAccent,
          primaryColor: Colors.black,
          accentColor: Theme.of(context).colorScheme.lightPurpleAccent,
          primaryColorDark: Colors.grey[800],
          primaryColorBrightness: Brightness.dark,
          primaryColorLight: Colors.grey[850],
          brightness: Brightness.dark,
          indicatorColor: Colors.white,
          canvasColor: Colors.black,
          appBarTheme: AppBarTheme(brightness: Brightness.dark),
          cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
              textTheme: CupertinoTextThemeData(primaryColor: Colors.white))),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Framework(
        pages: [
          HomePage(
              froshName: "Calum",
              discipline: "Engineering Science",
              froshGroup: "lambda"),
          SchedulePageParse(),
          NotificationsPageParse(),
          ResourcesPageParse(),
        ],
        isLoggedIn: preferences.getBool('isLoggedIn') ?? false,
        dio: dio,
      ),
    );
  }
}

class Framework extends StatefulWidget {
  final List<Widget> pages;
  final bool isLoggedIn;
  final Dio dio;

  const Framework({
    Key? key,
    required this.pages,
    required this.isLoggedIn,
    required this.dio,
  }) : super(key: key);

  @override
  FrameworkState createState() => FrameworkState();
}

class FrameworkState extends State<Framework> {
  late PageController pageController;
  int selectedIndex = 0;
  late bool _loggedIn;

  void setLoggedIn(bool login) {
    print("Logging in");
    setState(() {
      _loggedIn = login;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    _loggedIn = widget.isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn){
      return Scaffold(
        body: LoginPage(dio: widget.dio, setLoggedIn: setLoggedIn)
      );
    } else return Scaffold(
      body: Stack(children: [
        PageTransitionSwitcher(
          transitionBuilder: (
            child,
            animation,
            secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: widget.pages[selectedIndex],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0, 0.8),
                colors: [
                  Theme.of(context).canvasColor.withOpacity(0),
                  Theme.of(context).colorScheme.lightPurpleAccent,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CurvedNavigationBar(
            buttonBackgroundColor:
                Theme.of(context).colorScheme.lightPurpleAccent,
            color: Theme.of(context).colorScheme.lightPurpleAccent,
            animationDuration: const Duration(milliseconds: 500),
            backgroundColor: Colors.transparent,
            height: 60,
            items: <Widget>[
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.event,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.notifications,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.book,
                size: 30,
                color: Colors.white,
              ),
              // Icon(
              //   Icons.login,
              //   size: 30,
              //   color: Colors.white,
              // ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ]),
    );
  }
}
