import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../functions.dart";
import "../widgets/ContainersExtensions.dart";
// import "package:flutter_secure_storage/flutter_secure_storage.dart" as fss;
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import 'package:frosh_week_2t1/src/pages/resources_page.dart';
import 'package:frosh_week_2t1/src/widgets/ButtonWidgets.dart';

class HomePage extends StatefulWidget {
  final String froshName;
  final String froshGroup;
  final String froshId;
  final String discipline;
  final String shirtSize;
  final String welcomeMessage;
  final dynamic froshScheduleData;
  final Function setLoggedIn;

  const HomePage(
      {Key? key,
      required this.froshName,
      required this.froshGroup,
      required this.froshId,
      required this.discipline,
      required this.shirtSize,
      required this.welcomeMessage,
      required this.froshScheduleData,
        required this.setLoggedIn,
      })
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uCheckPass =
      "pass"; //one of pass, fail, incomplete (incomplete is fail)

  handleUCheckChange(bool status) {
    print("ucheckStatus:" + status.toString());
  }

  @override
  Widget build(BuildContext context) {
    print(widget.froshName);
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
          // Header(text: "Welcome Calum", padding: true),
          InkWell(
            onTap: () {
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
                    outline: !(uCheckPass == "fail"),
                    customWidth:
                        MediaQuery.of(context).size.width / 2 - 16 - 20 * 2,
                    text: "UCheck Fail",
                    onPressed: () async {
                      setState(() {
                        if (uCheckPass == "fail") {
                          uCheckPass = "incomplete";
                        } else {
                          uCheckPass = "fail";
                        }
                      });
                      handleUCheckChange(false);
                    }),
                ButtonRegular(
                    outline: !(uCheckPass == "pass"),
                    customWidth:
                        MediaQuery.of(context).size.width / 2 - 16 - 20 * 2,
                    text: "UCheck Pass",
                    onPressed: () async {
                      if (uCheckPass == "pass") {
                        handleUCheckChange(false);
                      } else {
                        handleUCheckChange(true);
                      }
                      setState(() {
                        if (uCheckPass == "pass") {
                          uCheckPass = "incomplete";
                        } else {
                          uCheckPass = "pass";
                        }
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
              SharedPreferences preferences = await SharedPreferences.getInstance();
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
