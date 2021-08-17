import 'package:flutter/material.dart';
import '../widgets/TextWidgets.dart';
import '../widgets/qr_scanner.dart';

class LeadersPage extends StatelessWidget {
  getStrings(String output) {
    print(output);
  }

  Widget build(BuildContext context) {
    return Scaffold(body: QRScanner(setValues: getStrings));
  }
}
