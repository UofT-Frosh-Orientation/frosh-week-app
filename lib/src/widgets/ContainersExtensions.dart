import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/functions.dart';
import "../widgets/Containers.dart";
import '../widgets/TextWidgets.dart';
import 'package:frosh_week_2t1/src/pages/schedule_page.dart';
import '../colors.dart';
import '../pages/resources_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ContainerEvent extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final String? room;
  final String color;
  final String? link;

  const ContainerEvent({
    Key? key,
    required this.title,
    required this.time,
    required this.description,
    this.room,
    this.color = "purple",
    this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == "") {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: TextFont(
            textAlign: TextAlign.center,
            text: "There are no events right now.",
          ),
        ),
      );
    }
    var eventBox = Box(
        fancy: true,
        colors: determineEventColorFromColor(color),
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFont(
              text: title,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
            ),
            Container(height: 3),
            time != ""
                ? TextFont(
                    text: time,
                    fontSize: 17,
                    textAlign: TextAlign.right,
                    textColor: Colors.white,
                  )
                : Container(),
            room != null
                ? TextFont(
                    text: "$room",
                    fontSize: 17,
                    textColor: Colors.white,
                  )
                : Container(),
            link != null && link != ""
                ? TextFont(
                    text: cutUrl("$link"),
                    fontSize: 17,
                    textColor: Theme.of(context).colorScheme.darkPurpleAccent,
                  )
                : Container(),
            Container(height: 5),
            TextFont(
              text: description,
              fontSize: 15,
              textColor: Colors.white,
            ),
          ],
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(
          text: "Happening Now",
          padding: true,
        ),
        link != null && link != ""
            ? InkWell(
                onTap: () async {
                  var url = link!;
                  if (await canLaunch(url))
                    await launch(url);
                  else {
                    Clipboard.setData(ClipboardData(text: "$link"));
                    showSnackbar(
                        context,
                        "There was an error launching the url.\nThe url has been copied to your clipboard.",
                        Theme.of(context).colorScheme.white,
                        Theme.of(context).colorScheme.black);
                  }
                },
                child: eventBox,
              )
            : eventBox,
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
                  textColor: Colors.white,
                ),
                TextFont(
                  text: "$froshGroup",
                  textColor: Colors.white,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextFont(
                    text: "$froshName",
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            TextFont(
              text: "$discipline",
              fontSize: 15,
              textColor: Colors.white,
            ),
          ],
        ),
      )),
    );
  }
}
