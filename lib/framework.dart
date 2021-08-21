import 'dart:async';
import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:frosh_week_2t1/src/pages/home_page.dart';
import 'package:frosh_week_2t1/src/pages/leaders_page.dart';
import 'package:frosh_week_2t1/src/pages/notifications_page.dart';
import 'package:frosh_week_2t1/src/pages/resources_page.dart';
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "src/functions.dart";

List<String> convertToStringList(List<dynamic> data) {
  List<String> converted = data.map((item) {
    return jsonEncode(item);
  }).toList();
  return converted;
}

List<Map<String, dynamic>> convertFromStringList(List<String> data) {
  List<Map<String, dynamic>> converted = data.map((item) {
    return jsonDecode(item) as Map<String, dynamic>;
  }).toList();
  return converted;
}

class Framework extends StatefulWidget {
  final bool isLoggedIn;
  final bool isLeader;
  final Dio dio;
  final fss.FlutterSecureStorage storage;
  final dynamic loadedData;
  final Function setLoggedIn;

  const Framework({
    Key? key,
    required this.isLoggedIn,
    required this.isLeader,
    required this.dio,
    required this.storage,
    required this.loadedData,
    required this.setLoggedIn,
  }) : super(key: key);

  @override
  FrameworkState createState() => FrameworkState();
}

class FrameworkState extends State<Framework> {
  late PageController pageController;
  int selectedIndex = 0;
  String froshName = "";
  String froshGroup = "";
  String froshEmail = "";
  String discipline = "";
  String shirtSize = "";
  Completer<bool> completer = new Completer();
  dynamic data = [];

  // Future<void> setLoggedIn(bool login) async {
  //   setState(() {
  //     _loggedIn = login;
  //   });
  //   if (login) {
  //     await getCurrentUser();
  //   }
  // }

  Future<bool> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await hasNetwork()) {
      String? cookie = await widget.storage.read(key: 'cookie');
      Response res = await widget.dio
          .get(
              widget.isLeader
                  ? 'https://www.orientation.skule.ca/exec/current'
                  : 'https://www.orientation.skule.ca/users/current',
              options: Options(headers: {"cookie": cookie}))
          .catchError((error) {
        widget.setLoggedIn(false, false);
      });
      if (res.data.toString() == "{}") {
        widget.setLoggedIn(false, false);
        completer.complete(false);
        return false;
      }
      if (widget.isLeader) {
        setState(() {
          froshName = res.data["name"];
          froshGroup = res.data["froshGroup"];
          froshEmail = res.data["_id"];
          discipline = "";
          shirtSize = "Medium";
        });
      } else {
        setState(() {
          froshName = res.data["preferredName"];
          froshGroup = res.data["froshGroup"];
          froshEmail = res.data["email"];
          discipline = res.data["discipline"];
          shirtSize = res.data["shirtSize"];
        });
      }
      await prefs.setStringList('froshData',
          [froshName, froshGroup, froshEmail, discipline, shirtSize]);
      // subscribe to topic on each app start-up
      String? token = await FirebaseMessaging.instance.getToken();
      await FirebaseMessaging.instance.subscribeToTopic(froshGroup);
      if (widget.isLeader) {
        await FirebaseMessaging.instance.subscribeToTopic("leaders");
        await FirebaseMessaging.instance.subscribeToTopic("${froshGroup}Leaders");
      }
      Response res2 = await widget.dio
          .post('https://www.orientation.skule.ca/app/firebase-token',
              data: {
                "email": froshEmail,
                "execId": froshEmail,
                "isFrosh": !widget.isLeader,
                "firebaseToken": token
              },
              options: Options(headers: {"cookie": cookie}));
      Response res3 = await widget.dio.get(
          "https://www.orientation.skule.ca/app/schedule?froshGroup=${froshGroup == 'all' ? 'alpha' : froshGroup.toLowerCase()}");
      setState(() {
        data = res3.data;
      });
      completer.complete(true);
      //This can complete in the background
      await prefs.setStringList('schedule', convertToStringList(res3.data));
      return true;
    } else {
      List<String>? froshData = prefs.getStringList("froshData");
      List<String>? _schedule = prefs.getStringList("schedule");
      // List<String>
      setState(() {
        froshName = froshData![0];
        froshGroup = froshData[1];
        froshEmail = froshData[2];
        discipline = froshData[3];
        shirtSize = froshData[4];
        data = convertFromStringList(_schedule!);
      });
      completer.complete(true);
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = widget.isLeader
        ? [
            HomePage(
              froshName: froshName,
              froshGroup: froshGroup,
              froshAccount: froshEmail,
              discipline: discipline,
              shirtSize: shirtSize,
              froshScheduleData: data,
              welcomeMessage: widget.loadedData["welcomeMessage"],
              setLoggedIn: widget.setLoggedIn,
            ),
            SchedulePage(data: data),
            NotificationsPageParse(),
            ResourcesPageParse(),
            LeadersPage(
              leaderId: froshEmail,
              storage: widget.storage,
            ),
          ]
        : [
            HomePage(
              froshName: froshName,
              froshGroup: froshGroup,
              froshAccount: froshEmail,
              discipline: discipline,
              shirtSize: shirtSize,
              froshScheduleData: data,
              welcomeMessage: widget.loadedData["welcomeMessage"],
              setLoggedIn: widget.setLoggedIn,
            ),
            SchedulePage(data: data),
            NotificationsPageParse(),
            ResourcesPageParse(),
          ];
    List<Widget> icons = widget.isLeader
        ? [
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
            Icon(
              Icons.people,
              size: 30,
              color: Colors.white,
            ),
          ]
        : [
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
          ];

    return FutureBuilder(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Stack(children: [
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
                            Theme.of(this.context)
                                .colorScheme
                                .lightPurpleAccent,
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
                      color:
                          Theme.of(this.context).colorScheme.lightPurpleAccent,
                      animationDuration: const Duration(milliseconds: 375),
                      backgroundColor: Colors.transparent,
                      height: 60,
                      items: icons,
                      onTap: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ]),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
