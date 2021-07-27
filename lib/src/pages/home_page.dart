import 'package:flutter/material.dart';
import '../widgets/FroshQR.dart';

class HomePage extends StatelessWidget {
  final String froshName;

  const HomePage({
    Key? key,
    required this.froshName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome to F!rosh, $froshName",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              FroshQR(
                  froshAccount: "some_account_id",
                  froshKitsSize: "Large",
                  hasCompletedUCheck: true
              )
            ],
          ),
        ));
  }
}
