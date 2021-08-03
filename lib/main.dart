import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import 'package:frosh_week_2t1/src/pages/login_page.dart';
import 'src/pages/home_page.dart';
import 'src/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

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
          return MyApp();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        //TODO: add a loading page
        return MyApp();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: Framework(pages: [
        LoginPage(),
        HomePage(
            froshName: "Calum",
            discipline: "Engineering Science",
            froshGroup: "Lambda"),
        SchedulePage(),
      ]),
    );
  }
}

class Framework extends StatefulWidget {
  final pages;

  const Framework({
    Key? key,
    required this.pages,
  }) : super(key: key);

  @override
  FrameworkState createState() => FrameworkState();
}

class FrameworkState extends State<Framework> {
  late PageController pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: widget.pages,
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
                  Theme.of(context).colorScheme.purpleAccent,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CurvedNavigationBar(
            buttonBackgroundColor:
                Theme.of(context).colorScheme.lightDarkAccent,
            color: Theme.of(context).colorScheme.navbar,
            animationDuration: const Duration(milliseconds: 500),
            backgroundColor: Colors.transparent,
            height: 60,
            items: <Widget>[
              Icon(
                Icons.home,
                size: 30,
                color: Theme.of(context).colorScheme.black,
              ),
              Icon(
                Icons.notifications,
                size: 30,
                color: Theme.of(context).colorScheme.black,
              ),
              Icon(
                Icons.home,
                size: 30,
                color: Theme.of(context).colorScheme.black,
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              pageController.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic);
            },
          ),
        ),
      ]),
    );
  }
}
