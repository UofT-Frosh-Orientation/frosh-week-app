import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/TextWidgets.dart';

class ButtonRegular extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool outline;
  final bool yellow;

  const ButtonRegular({
    Key? key,
    required this.text,
    required this.onPressed,
    this.outline = false,
    this.yellow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.outline) {
      return Container(
        width: MediaQuery.of(context).size.width - 18 * 2,
        child: Container(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(
                    color: yellow
                        ? Theme.of(context).colorScheme.yellowAccent
                        : Theme.of(context).colorScheme.lightLightPurpleAccent,
                    width: 3),
                padding: EdgeInsets.all(18)),
            onPressed: onPressed,
            child: TextFont(
              text: text,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width - 18 * 2,
        child: Container(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(yellow
                  ? Theme.of(context).colorScheme.yellowAccent
                  : Theme.of(context).colorScheme.lightPurpleAccent),
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
}
