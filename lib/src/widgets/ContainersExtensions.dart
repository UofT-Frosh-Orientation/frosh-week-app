import 'package:flutter/material.dart';
import '../colors.dart';
import "../widgets/Containers.dart";
import '../widgets/TextWidgets.dart';

class ContainerEvent extends StatelessWidget {
  final String title;
  final String time;
  final String room;
  final String description;
  final bool blackText;
  final bool small;

  const ContainerEvent({
    Key? key,
    required this.title,
    required this.time,
    required this.room,
    required this.description,
    this.blackText = false,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget descriptionWidget = Padding(
      padding: const EdgeInsets.only(left: 23, right: 23, bottom: 23),
      child: TextFont(
        text: "$description",
        fontSize: small ? 16 : 18,
        customTextColor: blackText ? true : false,
        textColor: Colors.black,
      ),
    );
    if (description == "") {
      descriptionWidget = Container();
    }
    Widget innerWidget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: ExpansionTile(
        childrenPadding: small ? null : EdgeInsets.all(0),
        tilePadding: small ? EdgeInsets.only(right: 10) : EdgeInsets.all(0),
        expandedAlignment: Alignment.centerLeft,
        title: Padding(
          padding: EdgeInsets.only(
              left: 23, top: small ? 10 : 23, bottom: small ? 10 : 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: TextFont(
                  text: "$title",
                  fontSize: small ? 24 : 30,
                  fontWeight: FontWeight.bold,
                  customTextColor: blackText ? true : false,
                  textColor: Colors.black,
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFont(
                      text: "$time",
                      fontSize: 16,
                      customTextColor: blackText ? true : false,
                      textColor: Colors.black,
                      textAlign: TextAlign.right,
                    ),
                    TextFont(
                      text: "$room",
                      fontSize: 15,
                      customTextColor: blackText ? true : false,
                      textColor: Colors.black,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        trailing: small ? null : Container(height: 0, width: 0),
        children: [descriptionWidget],
      ),
    );
    if (small) {
      return innerWidget;
    } else {
      return (Box(
          outerPadding: 0,
          fancy: true,
          colors: [Color(0xAFFF8447), Color(0xB6FDE938), Color(0xB6F18B32)],
          widget: innerWidget));
    }
  }
}

class ContainerFrosh extends StatelessWidget {
  final String froshName;
  final String discipline;
  final String froshGroup;

  const ContainerFrosh({
    Key? key,
    required this.froshName,
    required this.discipline,
    required this.froshGroup,
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
                  text: "Hello",
                  fontSize: 27,
                  customTextColor: true,
                  textColor: Colors.white,
                ),
                TextFont(
                  text: "λ Lambda",
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
