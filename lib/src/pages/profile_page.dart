import 'package:flutter/material.dart';
import '../widgets/FroshQR.dart';
import "../widgets/Containers.dart";
import "../widgets/ContainersExtensions.dart";
import 'package:device_display_brightness/device_display_brightness.dart';

class ProfilePage extends StatelessWidget {
  final String froshName;
  final String froshGroup;
  final String froshAccount;
  final String discipline;
  final String shirtSize;
  final String welcomeMessage;
  final bool hasCompletedUCheck;

  const ProfilePage(
      {Key? key,
      required this.froshName,
      required this.froshGroup,
      required this.froshAccount,
      required this.discipline,
      required this.shirtSize,
      required this.welcomeMessage,
      required this.hasCompletedUCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 10 || details.delta.dx > 10) {
          DeviceDisplayBrightness.resetBrightness();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(''),
            leading: Container(),
            actions: [
              ExitButton(onTap: () {
                DeviceDisplayBrightness.resetBrightness();
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
                    welcomeMessage: welcomeMessage),
                Container(height: 20),
                Center(
                  child: FroshQR(
                      froshName: froshName,
                      froshAccount: froshAccount,
                      froshKitsSize: shirtSize,
                      hasCompletedUCheck: hasCompletedUCheck),
                ),
              ]),
            )
          ])),
    );
  }
}
