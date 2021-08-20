import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/widgets/ButtonWidgets.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/qr_scanner.dart';
import "../widgets/Containers.dart";
import '../widgets/TextInputWidgets.dart';

class LeadersPage extends StatefulWidget {
  const LeadersPage({
    Key? key,
  }) : super(key: key);

  @override
  LeadersPageState createState() => LeadersPageState();
}

const defaultScannedStrings = ["", "", "", ""];
int numFields = defaultScannedStrings.length;

class LeadersPageState extends State<LeadersPage> {
  List<String> scannedStrings = defaultScannedStrings;

  bool hasLoaded = false;

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
        Box(
            widget: Column(children: [
          TextFont(text: "Name:"),
          TextFont(
              text: scannedStrings[0],
              fontSize: 24,
              fontWeight: FontWeight.bold),
          TextFont(text: "Frosh:"),
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
                  scannedStrings = ["", "", ""];
                });
              },
            ),
            ButtonRegular(
              yellow: true,
              text: "Register",
              customWidth: MediaQuery.of(context).size.width / 2 - 32 * 2,
              onPressed: () async {
                print("register frosh");
                setState(() {
                  scannedStrings = ["", "", ""];
                });
              },
            ),
          ]),
        ])),
        Container(height: 30),
        ButtonRegular(
          text: "Scan QR Code",
          onPressed: () async {
            setState(() {
              scannedStrings = ["", "", ""];
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
                  content: const Text('There was an error scanning'),
                ));
              }
            });
          },
        ),
        Container(height: 30),
        DropDownButton(
            title: "Location",
            items: ["King's college circle", "Myhal", "Orientation"],
            onChanged: (value) {
              print(value);
            }),
        Container(height: 20),
        TextInput(
            labelText: "Manual sign-in",
            onSubmitted: (text) {
              print(text);
            }),
        Container(height: 7),
        Center(
          child: TextFont(
            text: "Use the Frosh's email to sign-in manually",
            fontSize: 10,
          ),
        ),
        Container(height: 100),
      ]))
    ]));
  }
}
