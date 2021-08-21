import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/widgets/ButtonWidgets.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/qr_scanner.dart';
import "../widgets/Containers.dart";
import '../widgets/TextInputWidgets.dart';
import '../colors.dart';

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
                      print("register frosh");
                      setState(() {
                        scannedStrings = defaultScannedStrings;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: TextFont(
                            text: '🎉 Frosh Registered',
                            fontSize: 16,
                            textColor: Theme.of(context).colorScheme.white,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.black,
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
            onSubmitted: (text) {
              print("Submitted");
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
            }),
        Container(height: 100),
      ]))
    ]));
  }
}
