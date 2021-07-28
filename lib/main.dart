import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'src/pages/home_page.dart';
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
        primaryColor: Colors.white,
        primaryColorLight: Colors.grey[100],
        primaryColorDark: Colors.black,
        shadowColor: Colors.grey[100],
        primaryColorBrightness: Brightness.light,
        brightness: Brightness.light,
        canvasColor: Colors.grey[100],
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        cupertinoOverrideTheme:
            const CupertinoThemeData(brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
          primaryColor: Colors.black,
          primaryColorBrightness: Brightness.dark,
          primaryColorLight: Colors.grey[850],
          brightness: Brightness.dark,
          primaryColorDark: Colors.black,
          indicatorColor: Colors.white,
          canvasColor: Colors.black,
          appBarTheme: AppBarTheme(brightness: Brightness.dark),
          cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
              textTheme: CupertinoTextThemeData(primaryColor: Colors.white))),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Framework(pages: [
        HomePage(
          froshName: "Calum",
        ),
        HomePage(
          froshName: "Calum",
        ),
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
                end: Alignment(0, 1.3),
                colors: [
                  Theme.of(context).canvasColor.withOpacity(0),
                  Colors.purple
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CurvedNavigationBar(
            animationDuration: const Duration(milliseconds: 500),
            backgroundColor: Colors.transparent,
            height: 60,
            items: <Widget>[
              Icon(
                Icons.home,
                size: 30,
                color: Colors.purple[800],
              ),
              Icon(Icons.notifications, size: 30),
              Icon(Icons.ac_unit, size: 30),
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
