import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/TextWidgets.dart';

class ButtonRegular extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonRegular({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 18 * 2,
      child: Container(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.lightPurpleAccent),
            padding: MaterialStateProperty.all(EdgeInsets.all(18)),
          ),
          onPressed: onPressed,
          child: TextFont(
            text: text,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
