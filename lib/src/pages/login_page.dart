import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/ButtonWidgets.dart';
import '../widgets/TextInputWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:dio/dio.dart";
import '../colors.dart';
import "../functions.dart";
import 'package:simple_animations/simple_animations.dart';

class LoginPage extends StatefulWidget {
  final Dio dio;
  final Function setLoggedIn;
  final fss.FlutterSecureStorage storage;
  const LoginPage({
    Key? key,
    required this.dio,
    required this.setLoggedIn,
    required this.storage,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  bool loginLeaderType = false;
  String error = '';
  bool loading = false;

  Future<void> _login({
    required String email,
    required String password,
    required bool isFrosh,
  }) async {
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
      error = '';
    });
    bool connected = await hasNetwork();
    if (!connected) {
      setState(() {
        loading = false;
        error = 'Please connect to the internet';
      });
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isFrosh) {
      Response res1 = await widget.dio.post(
        'https://www.orientation.skule.ca/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 400;
          },
        ),
      );
      if (email == "" || password == "" || res1.headers["location"] == null) {
        prefs.setBool('isLoggedIn', false);
        widget.setLoggedIn(false, false);
        setState(() {
          loading = false;
          error = "Please fill in the credentials";
        });
        return;
      }
      if (res1.headers["location"]![0] == "/login_success") {
        Headers headers = res1.headers;
        String cookie = headers["set-cookie"]![0]
            .substring(0, headers["set-cookie"]![0].indexOf(';'));
        await widget.storage.write(key: "cookie", value: cookie);
        prefs.setBool('isLoggedIn', true);
        widget.setLoggedIn(true, false);
        setState(() {
          loading = false;
        });
        return;
      }
      prefs.setBool('isLoggedIn', false);
      widget.setLoggedIn(false, false);
      setState(() {
        loading = false;
        error = "Please enter a valid password and email";
      });
    } else {
      Response res1 = await widget.dio.post(
        'https://www.orientation.skule.ca/exec/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 400;
          },
        ),
      );
      if (email == "" || password == "" || res1.headers["location"] == null) {
        prefs.setBool('isLoggedIn', false);
        widget.setLoggedIn(false, true);
        setState(() {
          loading = false;
          error = "Please fill in the credentials";
        });
        return;
      }
      if (res1.headers["location"]![0] == '/exec/login_success') {
        Headers headers = res1.headers;
        String cookie = headers["set-cookie"]![0]
            .substring(0, headers["set-cookie"]![0].indexOf(';'));
        await widget.storage.write(key: "cookie", value: cookie);
        prefs.setBool('isLoggedIn', true);
        prefs.setBool('isLeader', true);
        widget.setLoggedIn(true, true);
        setState(() {
          loading = false;
        });
        return;
      }
      prefs.setBool('isLoggedIn', false);
      widget.setLoggedIn(false, true);
      setState(() {
        loading = false;
        error = "Please enter a valid password and email";
      });
    }
  }

  int lastTap = DateTime.now().millisecondsSinceEpoch;
  int consecutiveTaps = 0;
  void triggerLeaderLogin() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlasmaRenderer(
          type: PlasmaType.bubbles,
          particles: 60,
          color: Theme.of(context).colorScheme.animatedBubbles,
          blur: 0.34,
          size: 0.22,
          speed: 0.46,
          offset: 0,
          blendMode: BlendMode.hardLight,
          particleType: ParticleType.atlas,
          variation1: 0.58,
          variation2: 0.12,
          variation3: 0.17,
          rotation: 0,
        ),
        Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Container(height: 70),
            GestureDetector(
              onTap: () {
                triggerLeaderLogin();
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
                  setState(() {
                    email = text;
                  });
                }),
            Container(height: 18),
            TextInput(
                obscureText: true,
                labelText: "Password",
                onChanged: (text) {
                  setState(() {
                    password = text;
                  });
                }),
            Container(height: 18),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: loading
                  ? Container(
                      width: 55,
                      height: 55,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.yellowAccent,
                      ),
                    )
                  : AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      switchInCurve: Curves.easeInOutCubic,
                      switchOutCurve: Curves.easeInOutCubic,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: loginLeaderType
                          ? Row(
                              key: ValueKey<bool>(loginLeaderType),
                              children: [
                                ButtonRegular(
                                    customWidth:
                                        MediaQuery.of(context).size.width / 2 -
                                            16 * 2,
                                    text: "Frosh Login",
                                    onPressed: () async {
                                      await _login(
                                        email: email,
                                        password: password,
                                        isFrosh: true,
                                      );
                                    }),
                                ButtonRegular(
                                    yellow: true,
                                    customWidth:
                                        MediaQuery.of(context).size.width / 2 -
                                            16 * 2,
                                    text: "Leader Login",
                                    onPressed: () async {
                                      await _login(
                                        email: email,
                                        password: password,
                                        isFrosh: false,
                                      );
                                    }),
                              ],
                            )
                          : ButtonRegular(
                              key: ValueKey<bool>(loginLeaderType),
                              text: "Login",
                              onPressed: () async {
                                await _login(
                                    email: email,
                                    password: password,
                                    isFrosh: true);
                              })),
            ),
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
                duration: Duration(milliseconds: 400),
                child: TextFont(
                  key: ValueKey<String>(error),
                  text: error,
                  fontSize: 16,
                  textColor: Theme.of(context).colorScheme.redAccent,
                ),
              ),
            ),
            Container(height: 60)
          ],
        ))),
      ],
    );
  }
}
