import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../colors.dart';

class FroshQR extends StatelessWidget {
  final String froshName;
  final String froshAccount;
  final String froshKitsSize;
  final bool hasCompletedUCheck;

  const FroshQR(
      {Key? key,
      required this.froshName,
      required this.froshAccount,
      required this.froshKitsSize,
      required this.hasCompletedUCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    var height = min(deviceWidth, deviceHeight);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Theme.of(context).colorScheme.qrBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: QrImage(
          data: "$froshName/$froshAccount/$froshKitsSize/$hasCompletedUCheck",
          version: QrVersions.auto,
          size: height * 0.7,
          foregroundColor: Theme.of(context).colorScheme.qrColor,
        ),
      ),
    );
  }
}
