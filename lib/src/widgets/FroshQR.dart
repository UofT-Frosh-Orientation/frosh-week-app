import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

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
    return QrImage(
      data: "$froshAccount/$froshKitsSize/$hasCompletedUCheck",
      version: QrVersions.auto,
      size: 320,
      foregroundColor: Colors.deepPurple,
    );
  }
}
