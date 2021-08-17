import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import "package:intl/intl.dart";

Future<void> _messageHandler(RemoteMessage message) async {
  final DateFormat dateFormat = DateFormat('H:mm a EEEE');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  late List<Map<String, dynamic>> notifications;
  List<String> rawNotifications = preferences.getStringList("notifications") ?? [];
  notifications = rawNotifications.map((notification){
    return jsonDecode(notification) as Map<String, dynamic>;
  }).toList();
  notifications.add({
    "title": message.notification!.title,
    "description": message.notification!.body,
    "time": dateFormat.format(message.sentTime!)
  });
  await preferences.setStringList("notifications", notifications.map((element){
    return jsonEncode(element);
  }).toList());
}

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
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  Dio dio = Dio();
  runApp(App(preferences: preferences, dio: dio, storage: storage,));
}

class App extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
      home: MyApp(
        preferences: preferences,
        dio: dio,
        storage: storage,
      )
    );
  }
}


class MyApp extends StatefulWidget {
  final SharedPreferences preferences;
  final Dio dio;
  final fss.FlutterSecureStorage storage;

  const MyApp({
    Key? key,
    required this.preferences,
    required this.dio,
    required this.storage,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging messaging;
  late NotificationSettings notificationSettings;

  Future<void> getNotificationSettings(FirebaseMessaging _messaging) async {
    NotificationSettings _notificationSettings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // print(_notificationSettings);
    setState(() {
      notificationSettings = _notificationSettings;
    });
  }

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    getNotificationSettings(messaging);
    // messaging.getToken().then((value){
    //   // print("Token: $value");
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage event){
      _messageHandler(event);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Notification"),
            content: Text(event.notification!.body!),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Framework(
        isLoggedIn: widget.preferences.getBool('isLoggedIn') ?? false,
        dio: widget.dio,
        storage: widget.storage
    );
  }
}

class Framework extends StatefulWidget {
  final bool isLoggedIn;
  final Dio dio;
  final fss.FlutterSecureStorage storage;

  const Framework({
    Key? key,
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
  String froshGroup = "";
  String froshId = "";
  String discipline = "";
  String shirtSize = "";


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
      ).catchError((error){
        setState(() {
          _loggedIn = false;
        });
      });
      setState(() {
        froshName = res.data["preferredName"];
        froshGroup = res.data["froshGroup"];
        froshId = res.data["_id"];
        discipline = res.data["discipline"];
        shirtSize = res.data["shirtSize"];
      });
      await prefs.setStringList('froshData', [froshName, froshGroup, froshId, discipline, shirtSize]);
      return true;
    } else {
      List<String>? froshData = prefs.getStringList("froshData");
      setState(() {
        froshName = froshData![0];
        froshGroup = froshData[1];
        froshId = froshData[2];
        discipline = froshData[3];
        shirtSize = froshData[4];
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
    List<Widget> pages = [
      HomePage(
        froshName: froshName,
        froshGroup: froshGroup,
        froshId: froshId,
        discipline: discipline,
        shirtSize: shirtSize,
      ),
      SchedulePageParse(),
      NotificationsPageParse(),
      ResourcesPageParse(),
    ];
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
            child: pages[selectedIndex],
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
