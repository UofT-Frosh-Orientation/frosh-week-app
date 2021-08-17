import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../functions.dart";
import "../widgets/ContainersExtensions.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart" as fss;
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';

class HomePage extends StatefulWidget {
  final String froshName;
  final String froshGroup;
  final String froshId;
  final String discipline;
  final String shirtSize;
  final String welcomeMessage;
  final dynamic froshScheduleData;

  const HomePage(
      {Key? key,
      required this.froshName,
      required this.froshGroup,
      required this.froshId,
      required this.discipline,
      required this.shirtSize,
      required this.welcomeMessage,
      required this.froshScheduleData})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print(widget.froshName);
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
