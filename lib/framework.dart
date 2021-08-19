import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:frosh_week_2t1/src/pages/home_page.dart';
import 'package:frosh_week_2t1/src/pages/leaders_page.dart';
import 'package:frosh_week_2t1/src/pages/login_page.dart';
import 'package:frosh_week_2t1/src/pages/notifications_page.dart';
import 'package:frosh_week_2t1/src/pages/resources_page.dart';
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'src/colors.dart';

Future<bool> hasNetwork() async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

class Framework extends StatefulWidget {
  final bool isLoggedIn;
  final Dio dio;
  final fss.FlutterSecureStorage storage;
  final dynamic loadedData;

  const Framework({
    Key? key,
    required this.isLoggedIn,
    required this.dio,
    required this.storage,
    required this.loadedData,
  }) : super(key: key);

  @override
  FrameworkState createState() => FrameworkState();
}

class FrameworkState extends State<Framework> {
  late PageController pageController;
  int selectedIndex = 0;
  bool isLeader = false;
  late bool _loggedIn;
  String froshName = "";
  String froshGroup = "";
  String froshId = "";
  String discipline = "";
  String shirtSize = "";

  Future<void> setLoggedIn(bool login) async {
    setState(() {
      _loggedIn = login;
    });
    if (login) {
      await getCurrentUser();
    }
  }

  Future<bool> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLeader = prefs.getBool('isLeader') ?? false;
    });
    if (await hasNetwork()) {
      String? cookie = await widget.storage.read(key: 'cookie');
      Response res = await widget.dio
          .get(
              isLeader
                  ? 'https://www.orientation.skule.ca/exec/current'
                  : 'https://www.orientation.skule.ca/users/current',
              options: Options(headers: {"cookie": cookie}))
          .catchError((error) {
        setState(() {
          _loggedIn = false;
        });
      });
      if (isLeader) {
        setState(() {
          froshName = res.data["name"];
          froshGroup = res.data["froshGroup"];
          froshId = res.data["_id"];
          discipline = "";
          shirtSize = "Medium";
        });
      } else {
        setState(() {
          froshName = res.data["preferredName"];
          froshGroup = res.data["froshGroup"];
          froshId = res.data["_id"];
          discipline = res.data["discipline"];
          shirtSize = res.data["shirtSize"];
        });
      }
      await prefs.setStringList(
          'froshData', [froshName, froshGroup, froshId, discipline, shirtSize]);
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
        froshScheduleData: widget.loadedData["scheduleJSON"]["lambda"],
        welcomeMessage: widget.loadedData["welcomeMessage"],
        setLoggedIn: setLoggedIn,
      ),
      SchedulePage(data: widget.loadedData["scheduleJSON"]["lambda"]),
      NotificationsPageParse(),
      ResourcesPageParse(),
    ];
    List<Widget> icons = [
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

    if (isLeader) {
      pages.add(LeadersPage());
      icons.add(
        Icon(
          Icons.people,
          size: 30,
          color: Colors.white,
        ),
      );
    }

    if (!_loggedIn) {
      return Scaffold(
          body: LoginPage(
              dio: widget.dio,
              setLoggedIn: setLoggedIn,
              storage: widget.storage));
    } else
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
  }
}
