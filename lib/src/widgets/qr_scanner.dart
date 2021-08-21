import 'dart:io';
import '../colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  /// A [Function] which accepts a [String] as its argument. This is to be used to extract
  /// the state of this widget and use it in a page. It should probably call setState((){})
  /// and set a state value in the parent Widget which this widget is nested within.
  final Function setValues;
  const QRScanner({Key? key, required this.setValues}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  int count = 0;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  //TODO: Add button to flip camera
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Container(
      child: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).colorScheme.purpleAccent,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutBottomOffset: 30,
            cutOutSize: scanArea),
        onQRViewCreated: (QRViewController controller) async {
          this.controller = controller;
          try {
            final result = await controller.scannedDataStream.first;
            Navigator.pop(context, result.code);
          } catch (_) {
            print('QR error');
          }
        },
      ),
    );
  }
}
