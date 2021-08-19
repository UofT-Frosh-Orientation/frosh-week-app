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

class LeadersPageState extends State<LeadersPage> {
  List<String> scannedStrings = ["", "", ""];
  bool hasLoaded = false;
  getStrings(String output) {
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
          TextFont(text: "Frosh:"),
          TextFont(
              text: scannedStrings[0],
              fontSize: 24,
              fontWeight: FontWeight.bold),
          TextFont(text: "Shirt size:"),
          TextFont(
              text: scannedStrings[1],
              fontSize: 24,
              fontWeight: FontWeight.bold),
          TextFont(text: "Completed UCheck:"),
          TextFont(
            text: scannedStrings[2],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ])),
        Container(height: 30),
        ButtonRegular(
          text: "Scan QR Code",
          onPressed: () async {
            setState(() {
              scannedStrings = ["", "", ""];
            });
            final result = await Navigator.push(context, MaterialPageRoute<String>(builder: (BuildContext context) {
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
              scannedStrings = result!.split("/");
            });
          },
        ),
        Container(height: 20),
        TextInput(
            obscureText: true,
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
