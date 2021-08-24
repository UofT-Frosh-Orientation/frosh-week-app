import 'package:connectivity_plus/connectivity_plus.dart';
import './widgets/TextWidgets.dart';
import 'package:flutter/material.dart';
import './colors.dart';

const welcomeMessages = [
  "Hello",
  "Hi",
  "How are you?",
  "Hi there",
  "Hello there",
  "Hi!",
  "Hello!",
  "Hello there!",
  "Hi there!",
  "What's up?",
  "Welcome",
  "Welcome!",
  "Good day,",
];

const froshGroupSymbols = {
  'all': "α",
  'alpha': "α",
  'beta': "β",
  'gamma': "γ",
  'delta': "δ",
  'zeta': "ζ",
  'theta': "θ",
  'kappa': "κ",
  'iota': "ι",
  'lambda': "λ",
  'ni': "ν",
  'omicron': "ο",
  'pi': "π",
  'rho': "ρ",
  'sigma': "σ",
  'tau': "τ",
  'upsilon': "ε",
  'phi': "φ",
  'chi': "χ",
  'psi': "ψ",
  'omega': "ω",
};

showSnackbar(context, text, Color? textColor, Color? backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: TextFont(
        text: text,
        fontSize: 16,
        textColor:
            textColor == null ? Theme.of(context).colorScheme.white : textColor,
      ),
      backgroundColor: backgroundColor == null
          ? Theme.of(context).colorScheme.black
          : backgroundColor));
  return;
}

extension CapExtension on String {
  String get capitalizeFirst =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalizeFirst)
      .join(" ");
}

Future<bool> hasNetwork() async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

cutUrl(String url) {
  var splitUrl = url.split("/");
  var splitUrlEnd = "";
  if (splitUrl.length > 3 && splitUrl[3] != "") {
    splitUrlEnd = "...";
  }
  return splitUrl[0] +
      "/" +
      splitUrl[1] +
      "/" +
      splitUrl[2] +
      "/" +
      splitUrlEnd;
}
