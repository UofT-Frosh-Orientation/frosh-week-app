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
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final fss.FlutterSecureStorage storage = new fss.FlutterSecureStorage();
  Dio dio = Dio();
  runApp(App(preferences: preferences, dio: dio, storage: storage,));
}

class App extends StatefulWidget {
  final SharedPreferences preferences;
  final Dio dio;
  final fss.FlutterSecureStorage storage;
  const App({
    Key? key,
    required this.preferences,
    required this.dio,
    required this.storage
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
          return MyApp(preferences: widget.preferences, dio: widget.dio, storage: widget.storage);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp(preferences: widget.preferences, dio: widget.dio, storage: widget.storage);
        }

        //TODO: add a loading page
        return MyApp(preferences: widget.preferences, dio: widget.dio, storage: widget.storage);
      },
    );
  }
}


class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  final Dio dio;
  final fss.FlutterSecureStorage storage;

  const MyApp({
    Key? key,
    required this.preferences,
    required this.dio,
    required this.storage,
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
        storage: storage
      ),
    );
  }
}

class Framework extends StatefulWidget {
  final List<Widget> pages;
  final bool isLoggedIn;
  final Dio dio;
  final fss.FlutterSecureStorage storage;

  const Framework({
    Key? key,
    required this.pages,
    required this.isLoggedIn,
    required this.dio,
    required this.storage,
  }) : super(key: key);

  @override
  FrameworkState createState() => FrameworkState();
}

class FrameworkState extends State<Framework> {
  late PageController pageController;
  int selectedIndex = 0;
  late bool _loggedIn;
  String froshName = "";
  String discipline = "";
  String froshGroup = "";

  Future<void> setLoggedIn(bool login) async{
    setState(() {
      _loggedIn = login;
    });
    if (login) {
      await getCurrentUser();
    }
  }
  
  Future<bool> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await hasNetwork()) {
      String? cookie = await widget.storage.read(key: 'cookie');
      Response res = await widget.dio.get(
          'https://www.orientation.skule.ca/users/current',
          options: Options(
              headers: {"cookie": cookie}
          )
      );
      setState(() {
        froshName = res.data["preferredName"];
        froshGroup = res.data["froshGroup"];
        discipline = res.data["discipline"];
      });
      await prefs.setStringList('froshData', [froshName, froshGroup, discipline]);
      return true;
    } else {
      List<String>? froshData = prefs.getStringList("froshData");
      setState(() {
        froshName = froshData![0];
        froshGroup = froshData[1];
        discipline = froshData[2];
      });
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    setLoggedIn(widget.isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn){
      return Scaffold(
        body: LoginPage(dio: widget.dio, setLoggedIn: setLoggedIn, storage: widget.storage)
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
                    Theme.of(this.context).canvasColor.withOpacity(0),
                    Theme.of(this.context).colorScheme.lightPurpleAccent,
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CurvedNavigationBar(
              buttonBackgroundColor:
              Theme.of(this.context).colorScheme.lightPurpleAccent,
              color: Theme.of(this.context).colorScheme.lightPurpleAccent,
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
