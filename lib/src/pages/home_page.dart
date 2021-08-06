import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/pages/profile_page.dart';
import '../widgets/TextWidgets.dart';
import 'package:flutter/cupertino.dart';
import "../functions.dart";
import "../widgets/ContainersExtensions.dart";

const froshGroupSymbols = {
  'phi': "φ",
  'iota': "ι",
  'rho': "ρ",
  'psi': "ψ",
  'gamma': "γ",
  'zeta': "ζ",
  'omega': "ω",
  'upsilon': "ε",
  'beta': "β",
  'chi': "χ",
  'ni': "ν",
  'sigma': "σ",
  'kappa': "κ",
  'omicron': "ο",
  'delta': "δ",
  'pi': "π",
  'alpha': "α",
  'tau': "τ",
  'lambda': "λ",
  'theta': "θ"
};

class HomePage extends StatelessWidget {
  final String froshName;
  final String discipline;
  final String froshGroup;

  const HomePage({
    Key? key,
    required this.froshName,
    required this.discipline,
    required this.froshGroup,
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
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return ProfilePage(
                  froshName: froshName,
                  discipline: discipline,
                  froshGroup:
                      (froshGroupSymbols[froshGroup.toLowerCase()] ?? "") +
                          " " +
                          froshGroup.capitalizeFirst,
                );
              }));
            },
            child: ContainerFrosh(
              froshName: froshName,
              froshGroup: (froshGroupSymbols[froshGroup.toLowerCase()] ?? "") +
                  " " +
                  froshGroup.capitalizeFirst,
              discipline: discipline,
            ),
          ),
          Container(height: 20),
          Header(
            text: "Happening Now",
            padding: true,
          ),
          ContainerEvent(
            title: "Lunch time",
            description:
                "Grab your snacks! It's lunch time. Food is provided so you don't need to worry. Head to the building to get your lunch bla bla bla bla bla",
            time: "12:00 - 2:00",
          ),
          Container(height: 100)
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
