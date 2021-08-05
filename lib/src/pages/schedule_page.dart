import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "../widgets/ScheduleList.dart";
import "../widgets/TextWidgets.dart";

class SchedulePage extends StatelessWidget {
  const SchedulePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(physics: BouncingScrollPhysics(), children: [
      MainHeader(
        text: 'Schedule',
        textSmaller: "2T1",
        icon: false,
      ),
      ScheduleListParse(),
      Container(height: 100),
    ]));
  }
}
