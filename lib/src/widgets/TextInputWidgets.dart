import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/TextWidgets.dart';

class TextInput extends StatelessWidget {
  final String labelText;
  final ValueChanged<String> onChanged;
  final bool obscureText;

  const TextInput({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: TextField(
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.purpleAccent,
                  width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.lightDarkAccent,
              ),
            ),
            labelText: labelText,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.black)),
        obscureText: obscureText,
        onChanged: (text) {
          onChanged(text);
        },
      ),
    );
  }
}
