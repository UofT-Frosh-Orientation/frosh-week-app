import "package:flutter/material.dart";

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6f1e88),
          ),
        ),
      ),
    );
  }
}
