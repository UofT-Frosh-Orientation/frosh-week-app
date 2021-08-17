import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../functions.dart";
import "../widgets/ContainersExtensions.dart";

class HomePage extends StatelessWidget {
  final String froshName;
  final String discipline;
  final String froshGroup;
  final String welcomeMessage;
  final dynamic froshScheduleData;

  const HomePage({
    Key? key,
    required this.froshName,
    required this.discipline,
    required this.froshGroup,
    required this.welcomeMessage,
    required this.froshScheduleData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
      // CupertinoSliverNavigationBar(
      //   largeTitle: Text('Frosh Week'),
      //   trailing: Text('2T1'),
      // ),
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
                    froshName: froshName,
                    discipline: discipline,
                    froshGroup:
                        (froshGroupSymbols[froshGroup.toLowerCase()] ?? "") +
                            " " +
                            froshGroup.capitalizeFirst,
                    welcomeMessage: welcomeMessage);
              }));
            },
            child: ContainerFrosh(
              froshName: froshName,
              froshGroup: (froshGroupSymbols[froshGroup.toLowerCase()] ?? "") +
                  " " +
                  froshGroup.capitalizeFirst,
              discipline: discipline,
              welcomeMessage: welcomeMessage,
            ),
          ),
          Container(height: 20),

          getNowEvent(froshScheduleData),
          Container(height: 100)
        ]),
      )
    ]));
    // body: SafeArea(
    //   child: Column(
    //     children: [
    //       FroshQR(
    //           froshAccount: "some_account_id",
    //           froshKitsSize: "Large",
    //           hasCompletedUCheck: true)
    //     ],
    //   ),
    // ));
  }
}
