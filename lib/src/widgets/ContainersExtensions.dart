import 'package:flutter/material.dart';
import '../colors.dart';
import "../widgets/Containers.dart";
import '../widgets/TextWidgets.dart';
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';

class ContainerEvent extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final String? room;
  final String color;

  const ContainerEvent({
    Key? key,
    required this.title,
    required this.time,
    required this.description,
    this.room,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == "") {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(
          text: "Happening Now",
          padding: true,
        ),
        Box(
            fancy: true,
            colors: determineEventColorFromColor(color),
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFont(
                  text: title,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  customTextColor: true,
                  textColor: Colors.white,
                ),
                Container(height: 3),
                time != ""
                    ? TextFont(
                        text: time,
                        fontSize: 17,
                        textAlign: TextAlign.right,
                        customTextColor: true,
                        textColor: Colors.white,
                      )
                    : Container(),
                room != null
                    ? TextFont(
                        text: room,
                        fontSize: 17,
                        customTextColor: true,
                        textColor: Colors.white,
                      )
                    : Container(),
                Container(height: 5),
                TextFont(
                  text: description,
                  fontSize: 15,
                  customTextColor: true,
                  textColor: Colors.white,
                ),
              ],
            )),
      ],
    );
  }
}

class ContainerFrosh extends StatelessWidget {
  final String froshName;
  final String discipline;
  final String froshGroup;
  final String welcomeMessage;

  const ContainerFrosh({
    Key? key,
    required this.froshName,
    required this.discipline,
    required this.froshGroup,
    required this.welcomeMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "froshProfileCard",
      child: (Box(
        fancy: true,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFont(
                  text: welcomeMessage,
                  fontSize: 27,
                  customTextColor: true,
                  textColor: Colors.white,
                ),
                TextFont(
                  text: "$froshGroup",
                  customTextColor: true,
                  textColor: Colors.white,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFont(
                  text: "$froshName",
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                  customTextColor: true,
                  textColor: Colors.white,
                ),
              ],
            ),
            TextFont(
              text: "$discipline",
              fontSize: 15,
              customTextColor: true,
              textColor: Colors.white,
            ),
          ],
        ),
      )),
    );
  }
}
