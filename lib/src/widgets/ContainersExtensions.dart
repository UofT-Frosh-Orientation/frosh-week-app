import 'package:flutter/material.dart';
import '../colors.dart';
import "../widgets/Containers.dart";
import '../widgets/TextWidgets.dart';

class ContainerEvent extends StatelessWidget {
  final String title;
  final String time;
  final String description;

  const ContainerEvent({
    Key? key,
    required this.title,
    required this.time,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Box(
        fancy: true,
        colors: [Color(0xD7FFED47), Color(0xCBF58B34), Color(0xB7F1DE32)],
        widget: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: TextFont(
                    text: title,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    customTextColor: true,
                    textColor: Colors.white,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFont(
                        text: time,
                        fontSize: 16,
                        textAlign: TextAlign.right,
                        customTextColor: true,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
            TextFont(
              text: description,
              fontSize: 16,
              customTextColor: true,
              textColor: Colors.white,
            ),
          ],
        ));
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
