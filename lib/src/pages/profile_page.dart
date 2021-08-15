import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/FroshQR.dart';
import '../widgets/TextWidgets.dart';
import "../widgets/Containers.dart";
import "../widgets/ContainersExtensions.dart";

class ProfilePage extends StatelessWidget {
  final String froshName;
  final String froshGroup;
  final String froshId;
  final String discipline;
  final String shirtSize;

  const ProfilePage({
    Key? key,
    required this.froshName,
    required this.froshGroup,
    required this.froshId,
    required this.discipline,
    required this.shirtSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 10) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(''),
            leading: Container(),
            actions: [
              ExitButton(onTap: () {
                Navigator.of(context).pop();
              }),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                ContainerFrosh(
                  froshName: froshName,
                  froshGroup: froshGroup,
                  discipline: discipline,
                ),
                Container(height: 20),
                Center(
                  child: FroshQR(
                      froshAccount: froshId,
                      froshKitsSize: shirtSize,
                      hasCompletedUCheck: true),
                ),
              ]),
            )
          ])),
    );
  }
}