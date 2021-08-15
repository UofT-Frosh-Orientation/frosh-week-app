import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/ButtonWidgets.dart';
import '../widgets/TextInputWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../widgets/ContainersExtensions.dart";
import "package:dio/dio.dart";

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

  Future<void> _login({required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response res1 = await widget.dio.post(
      'https://www.orientation.skule.ca/login',
      data: {
        'email': email,
        'password': password,
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) {return status! < 400;}
      )
    );
    if (res1.headers["location"]![0] == "/login_success"){
      Headers headers = res1.headers;
      print(headers);
      String cookie = headers["set-cookie"]![0].substring(0, headers["set-cookie"]![0].indexOf(';'));
      // Response res2 = await widget.dio.get(
      //     'https://www.orientation.skule.ca/users/current',
      //     options: Options(
      //         headers: {"cookie": cookie}
      //     )
      // );
      // print(res2.headers);
      // // await widget.db.insert(res2.data);
      // print(res2.data);
      // widget.setLoggedIn(true);
      await widget.storage.write(key: "cookie", value: cookie);
      prefs.setBool('isLoggedIn', true);
      print("Im here");
      widget.setLoggedIn(true);
      return;
    }
    prefs.setBool('isLoggedIn', false);
    widget.setLoggedIn(false);
  }

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
        ButtonRegular(
            text: "Login",
            onPressed: () async {
              await _login(email: email, password: password);
            }),
        Container(height: 100)
      ],
    )));
  }
}
