import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FroshQR extends StatelessWidget {
  final String froshAccount;
  final String froshKitsSize;
  final bool hasCompletedUCheck;

  const FroshQR(
      {Key? key,
      required this.froshAccount,
      required this.froshKitsSize,
      required this.hasCompletedUCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    var height = min(deviceWidth, deviceHeight);
    return QrImage(
      data: "$froshAccount/$froshKitsSize/$hasCompletedUCheck",
      version: QrVersions.auto,
      size: height * 0.7,
      foregroundColor: Colors.deepPurple,
    );
  }
}
