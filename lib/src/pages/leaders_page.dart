import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/widgets/ButtonWidgets.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/qr_scanner.dart';
import "../widgets/Containers.dart";
import '../widgets/TextInputWidgets.dart';
import '../colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;


Future<bool> signInFrosh(String leaderId, String froshEmail, String location, bool completedUCheck, Dio dio) async {
  Response res = await dio.post(
    'https://www.orientation.skule.ca/app/sign-in/',
    data: {
      "froshEmail": froshEmail,
      "leaderAccountId": leaderId,
      "location": location,
      "hasCompletedUCheck": completedUCheck,
      "dateTime": DateTime.now().toString()
    },
  );
  if (res.data["message"] == "Sign in successful!!") {
    return true;
  } else {
    return false;
  }
}



class LeadersPage extends StatefulWidget {
  final String leaderId;
  final fss.FlutterSecureStorage storage;
  const LeadersPage({
    Key? key,
    required this.leaderId,
    required this.storage
  }) : super(key: key);

  @override
  LeadersPageState createState() => LeadersPageState();
}

const defaultScannedStrings = ["", "", "", ""];
int numFields = defaultScannedStrings.length;

class LeadersPageState extends State<LeadersPage> {
  List<String> scannedStrings = defaultScannedStrings;
  Dio dio = Dio();
  bool hasLoaded = false;
  String location = "King's college circle";

  Future<bool> manualGetFrosh(String email) async {
    String? cookie = await widget.storage.read(key: 'cookie');
    Response res = await dio.post(
      'https://www.orientation.skule.ca/exec/manual-signin',
      data: {
        "email": email
      },
      options: Options(
        headers: {
          "cookie": cookie
        }
      )
    );
    if (res.data["errorMessage"] == "") {
      setState(() {
        scannedStrings = [
          res.data!["froshData"]["preferredName"],
          res.data["froshData"]["email"],
          res.data["froshData"]["shirtSize"],
          "true"
        ];
      });
      return true;
    }
    return false;
  }

  Future<void> updateLocations() async {
    Response res = await dio.get('https://www.orientation.skule.ca/app/locations')
  }

  getStrings(String output) {
    if (output.split("/").length == numFields)
      setState(() {
        scannedStrings = output.split("/");
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        MainHeader(
          text: 'Leader Page',
          textSmaller: "",
          icon: false,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 700),
          child: Box(
              key: ValueKey<String>(scannedStrings[1]),
              widget: Column(children: [
                TextFont(text: "Name:"),
                TextFont(
                    text: scannedStrings[0],
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                TextFont(text: "Frosh Email:"),
                TextFont(
                    text: scannedStrings[1],
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                TextFont(text: "Shirt size:"),
                TextFont(
                    text: scannedStrings[2],
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                TextFont(text: "Completed UCheck:"),
                TextFont(
                  text: scannedStrings[3],
                  fontSize: 24,
                  textColor: scannedStrings[3] == "false"
                      ? Theme.of(context).colorScheme.redAccent
                      : Theme.of(context).colorScheme.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
                Container(height: 5),
                Row(children: [
                  ButtonRegular(
                    yellow: true,
                    outline: true,
                    text: "Cancel",
                    customWidth: MediaQuery.of(context).size.width / 2 - 32 * 2,
                    onPressed: () async {
                      setState(() {
                        scannedStrings = defaultScannedStrings;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: TextFont(
                          text: '🛑 Registeration cancelled',
                          fontSize: 16,
                          textColor: Theme.of(context).colorScheme.white,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.redAccent,
                      ));
                    },
                  ),
                  ButtonRegular(
                    yellow: true,
                    text: "Register",
                    customWidth: MediaQuery.of(context).size.width / 2 - 32 * 2,
                    onPressed: () async {
                      bool wasSuccessful = await signInFrosh(widget.leaderId, scannedStrings[1], location, scannedStrings[3] == "true", dio);
                      setState(() {
                        scannedStrings = defaultScannedStrings;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: TextFont(
                            text: wasSuccessful ? '🎉 Frosh Registered' : '🛑 There was an error',
                            fontSize: 16,
                            textColor: Theme.of(context).colorScheme.white,
                          ),
                          backgroundColor: wasSuccessful ? Theme.of(context).colorScheme.black : Theme.of(context).colorScheme.redAccent,
                        ));
                      });
                    },
                  ),
                ]),
              ])),
        ),
        Container(height: 30),
        ButtonRegular(
          text: "Scan QR Code",
          onPressed: () async {
            setState(() {
              scannedStrings = defaultScannedStrings;
            });
            final result = await Navigator.push(context,
                MaterialPageRoute<String>(builder: (BuildContext context) {
              return GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy > 10) {
                    Navigator.pop(context, '');
                  }
                },
                child: Scaffold(
                    appBar: AppBar(
                      title: const Text(''),
                      leading: Container(),
                      actions: [
                        ExitButton(onTap: () {
                          Navigator.pop(context, '');
                        }),
                      ],
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    body: QRScanner(setValues: getStrings)),
              );
            }));
            setState(() {
              if (result != null && result.split("/").length == numFields)
                scannedStrings = result.split("/");
              else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: TextFont(
                    text: '🛑 There was an error reading the QR code',
                    fontSize: 16,
                    textColor: Theme.of(context).colorScheme.white,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.redAccent,
                ));
              }
            });
          },
        ),
        Container(height: 20),
        TextInput(
            labelText: "Manual sign-in",
            onSubmitted: (text) async {
              bool foundFrosh = await manualGetFrosh(text);
              if (!foundFrosh) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: TextFont(
                      text: '🛑 Unable to find a Frosh with that email',
                      fontSize: 16,
                      textColor: Theme.of(context).colorScheme.white,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.redAccent,
                ));
              }
            },
        ),
        Container(height: 7),
        Center(
          child: TextFont(
            text: "Use the Frosh's email to sign-in manually",
            fontSize: 10,
          ),
        ),
        Container(height: 30),
        DropDownButton(
            title: "Location",
            items: ["King's college circle", "Myhal", "Orientation"],
            onChanged: (value) {
              setState(() {
                location = value;
              });
            }),
        Container(height: 100),
      ]))
    ]));
  }
}
