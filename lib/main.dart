import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frosh_week_2t1/src/pages/login_page.dart';
import 'framework.dart';
import 'src/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import "package:intl/intl.dart";
import 'dart:math';
import '../src/functions.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  final DateFormat dateFormat = DateFormat('H:mm a EEEE');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  late List<Map<String, dynamic>> notifications;
  List<String> rawNotifications =
      preferences.getStringList("notifications") ?? [];
  notifications = rawNotifications.map((notification) {
    return jsonDecode(notification) as Map<String, dynamic>;
  }).toList();
  notifications.add({
    "title": message.notification!.title,
    "description": message.notification!.body,
    "time": dateFormat.format(message.sentTime!)
  });
  await preferences.setStringList(
      "notifications",
      notifications.map((element) {
        return jsonEncode(element);
      }).toList());
}

Future<dynamic> loadData() async {
  Random random = new Random();
  dynamic loadedData = {
    "welcomeMessage": welcomeMessages[random.nextInt(welcomeMessages.length)],
  };
  return loadedData;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final fss.FlutterSecureStorage storage = new fss.FlutterSecureStorage();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  Dio dio = Dio();
  final loadedData = await loadData();
  runApp(App(
    preferences: preferences,
    dio: dio,
    storage: storage,
    loadedData: loadedData,
  ));
}

class App extends StatelessWidget {
  final SharedPreferences preferences;
  final Dio dio;
  final fss.FlutterSecureStorage storage;
  final dynamic loadedData;
  const App(
      {Key? key,
      required this.preferences,
      required this.dio,
      required this.storage,
      required this.loadedData})
      : super(key: key);

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
          loadedData: loadedData,
        ));
  }
}

class MyApp extends StatefulWidget {
  final SharedPreferences preferences;
  final Dio dio;
  final fss.FlutterSecureStorage storage;
  final dynamic loadedData;

  const MyApp({
    Key? key,
    required this.preferences,
    required this.dio,
    required this.storage,
    required this.loadedData,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging messaging;
  late NotificationSettings notificationSettings;
  bool isLoggedIn = false;
  bool isLeader = false;

  Future<void> getNotificationSettings(FirebaseMessaging _messaging) async {
    NotificationSettings _notificationSettings =
        await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    setState(() {
      notificationSettings = _notificationSettings;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoggedIn = widget.preferences.getBool("isLoggedIn") ?? false;
      isLeader = widget.preferences.getBool('isLeader') ?? false;
    });

    messaging = FirebaseMessaging.instance;
    getNotificationSettings(messaging);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      return;
    });
  }

  void setLoggedIn(bool login, bool _isLeader) {
    setState(() {
      isLoggedIn = login;
      isLeader = _isLeader;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return !isLoggedIn
        ? Scaffold(
            body: LoginPage(
                dio: widget.dio,
                setLoggedIn: setLoggedIn,
                storage: widget.storage),
          )
        : Framework(
            isLoggedIn: widget.preferences.getBool('isLoggedIn') ?? false,
            isLeader: isLeader,
            dio: widget.dio,
            storage: widget.storage,
            loadedData: widget.loadedData,
            setLoggedIn: setLoggedIn,
          );
  }
}
