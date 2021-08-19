import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../functions.dart";
import "../widgets/ContainersExtensions.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart" as fss;
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import 'package:frosh_week_2t1/src/pages/resources_page.dart';
import 'package:frosh_week_2t1/src/widgets/ButtonWidgets.dart';
import 'package:device_display_brightness/device_display_brightness.dart';

class HomePage extends StatefulWidget {
  final String froshName;
  final String froshGroup;
  final String froshId;
  final String discipline;
  final String shirtSize;
  final String welcomeMessage;
  final dynamic froshScheduleData;
  final Function setLoggedIn;

  const HomePage({
    Key? key,
    required this.froshName,
    required this.froshGroup,
    required this.froshId,
    required this.discipline,
    required this.shirtSize,
    required this.welcomeMessage,
    required this.froshScheduleData,
    required this.setLoggedIn,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool uCheckPass = false; //one of pass, fail, incomplete (incomplete is fail)

  Future<void> handleUCheckChange(bool status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      uCheckPass = status;
    });
    preferences.setBool('uCheck', status);
  }

  Future<void> initializeUCheck() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      uCheckPass = preferences.getBool('uCheck') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeUCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
      SliverList(
        delegate: SliverChildListDelegate([
          MainHeader(
            text: 'F!rosh Week',
            textSmaller: "2T1",
            icon: true,
          ),
          Container(height: 10),
          InkWell(
            onTap: () {
              DeviceDisplayBrightness.setBrightness(1.0);
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return ProfilePage(
                  froshName: widget.froshName,
                  froshGroup:
                      (froshGroupSymbols[widget.froshGroup.toLowerCase()] ??
                              "") +
                          " " +
                          widget.froshGroup.capitalizeFirst,
                  froshId: widget.froshId,
                  discipline: widget.discipline,
                  shirtSize: widget.shirtSize,
                  welcomeMessage: widget.welcomeMessage,
                  hasCompletedUCheck: uCheckPass,
                );
              }));
            },
            child: ContainerFrosh(
              froshName: widget.froshName,
              froshGroup:
                  (froshGroupSymbols[widget.froshGroup.toLowerCase()] ?? "") +
                      " " +
                      widget.froshGroup.capitalizeFirst,
              discipline: widget.discipline,
              welcomeMessage: widget.welcomeMessage,
            ),
          ),
          Container(height: 20),
          getNowEvent(widget.froshScheduleData),
          Container(height: 20),
          ResourceBox(
            resource: Resource(
                icon: Icons.health_and_safety,
                title: "UCheck",
                contact:
                    "https://www.provost.utoronto.ca/planning-policy/utogether2020-a-roadmap-for-the-university-of-toronto/quercus-ucheck/",
                type: "url",
                description:
                    "Before coming to campus, complete a quick COVID-19 self-assessment through the UCheck web portal."),
          ),
          Container(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                ButtonRegular(
                    outline: !(uCheckPass == false),
                    customWidth:
                        MediaQuery.of(context).size.width / 2 - 16 - 20 * 2,
                    text: "UCheck Fail",
                    onPressed: () async {
                      setState(() {
                        uCheckPass = false;
                      });
                      handleUCheckChange(false);
                    }),
                ButtonRegular(
                    outline: !(uCheckPass == true),
                    customWidth:
                        MediaQuery.of(context).size.width / 2 - 16 - 20 * 2,
                    text: "UCheck Pass",
                    onPressed: () async {
                      if (uCheckPass == true) {
                        handleUCheckChange(false);
                      } else {
                        handleUCheckChange(true);
                      }
                      setState(() {
                        uCheckPass = true;
                      });
                    }),
              ],
            ),
          ),
          Container(height: 40),
          ButtonRegular(
            text: "Logout",
            outline: true,
            yellow: true,
            onPressed: () async {
              print("handle logout");
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              fss.FlutterSecureStorage storage = fss.FlutterSecureStorage();
              storage.deleteAll();
              preferences.setBool('isLoggedIn', false);
              widget.setLoggedIn(false);
            },
          ),
          Container(height: 100)
        ]),
      )
    ]));
  }
}
