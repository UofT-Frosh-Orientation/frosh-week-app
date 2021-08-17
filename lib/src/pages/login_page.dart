import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/ButtonWidgets.dart';
import '../widgets/TextInputWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import "../widgets/ContainersExtensions.dart";
import '../colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var loginLeaderType = false;
  var error = "";

  @override
  Widget build(BuildContext context) {
    int lastTap = DateTime.now().millisecondsSinceEpoch;
    int consecutiveTaps = 0;
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Container(height: 70),
        GestureDetector(
          onTap: () {
            int now = DateTime.now().millisecondsSinceEpoch;
            if (now - lastTap < 1000) {
              consecutiveTaps++;
              if (consecutiveTaps > 8) {
                if (!loginLeaderType) {
                  setState(() {
                    loginLeaderType = true;
                  });
                }
              }
            } else {
              consecutiveTaps = 0;
            }
            lastTap = now;
          },
          child: MainHeader(
            text: 'F!rosh Week',
            textSmaller: "2T1",
            icon: true,
            topSpace: false,
          ),
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
        AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: ButtonRegular(
                key: ValueKey<bool>(loginLeaderType),
                text: loginLeaderType ? "Leader Login" : "Login",
                yellow: loginLeaderType,
                onPressed: () {
                  print("login");
                  setState(() {
                    error = "Please try again later";
                  });
                  if (loginLeaderType) {
                    print("A leader is logging in");
                  } else {
                    print("A frosh is logging in");
                  }
                })),
        Container(height: 15),
        ButtonRegular(
          text: "Signup",
          onPressed: () async {
            var url = "https://www.orientation.skule.ca/registration";
            if (await canLaunch(url)) await launch(url);
          },
          outline: true,
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: TextFont(
              key: ValueKey<String>(error),
              text: error,
              customTextColor: true,
              textColor: Theme.of(context).colorScheme.redAccent,
            ),
          ),
        ),
        Container(height: 60)
      ],
    )));
  }
}
