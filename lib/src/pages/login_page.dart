import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/ButtonWidgets.dart';
import '../widgets/TextInputWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import "../widgets/ContainersExtensions.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        MainHeader(
          text: 'F!rosh Week',
          textSmaller: "2T1",
          icon: true,
          topSpace: false,
        ),
        Container(height: 24),
        Align(
            alignment: Alignment.topLeft,
            child: Header(text: "Login", padding: true)),
        Container(height: 15),
        TextInput(
            labelText: "Email",
            onChanged: (text) {
              print(text);
            }),
        Container(height: 18),
        TextInput(
            obscureText: true,
            labelText: "Password",
            onChanged: (text) {
              print(text);
            }),
        Container(height: 18),
        ButtonRegular(
            text: "Login",
            onPressed: () {
              print("login");
            }),
        Container(height: 15),
        ButtonRegular(
          text: "Signup",
          onPressed: () async {
            var url = "https://www.orientation.skule.ca/registration";
            if (await canLaunch(url)) await launch(url);
          },
          outline: true,
        ),
        Container(height: 100)
      ],
    )));
  }
}
