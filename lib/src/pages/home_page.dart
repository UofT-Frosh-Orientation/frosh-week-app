import 'package:flutter/material.dart';
import '../widgets/FroshQR.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../widgets/Containers.dart";

class HomePage extends StatelessWidget {
  final String froshName;

  const HomePage({
    Key? key,
    required this.froshName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
      // CupertinoSliverNavigationBar(
      //   largeTitle: Text('Frosh Week'),
      //   trailing: Text('2T1'),
      // ),
      SliverList(
        delegate: SliverChildListDelegate([
          MainHeader(
            text: 'F!rosh Week',
            textSmaller: "2T1",
            icon: true,
          ),
          Container(height: 10),
          // Header(text: "Welcome Calum", padding: true),
          Box(
            fancy: true,
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: "Hello",
                      fontSize: 27,
                    ),
                    TextFont(text: "λ Lambda"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFont(
                      text: "Calum",
                      fontSize: 37,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                TextFont(
                  text: "Engineering Science",
                  fontSize: 15,
                ),
              ],
            ),
          ),
          Container(height: 20),
          Header(
            text: "Happening Now",
            padding: true,
          )
          // FroshQR(
          //     froshAccount: "some_account_id",
          //     froshKitsSize: "Large",
          //     hasCompletedUCheck: true),
        ]),
      )
    ]));
    // body: SafeArea(
    //   child: Column(
    //     children: [
    //       FroshQR(
    //           froshAccount: "some_account_id",
    //           froshKitsSize: "Large",
    //           hasCompletedUCheck: true)
    //     ],
    //   ),
    // ));
  }
}
