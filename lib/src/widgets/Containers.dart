import 'package:flutter/material.dart';
import '../colors.dart';

class ExitButton extends StatelessWidget {
  final VoidCallback onTap;
  const ExitButton({Key? key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Exit',
        onPressed: onTap,
      ),
    );
  }
}

class Box extends StatelessWidget {
  final Widget widget;
  final bool fancy;
  final List<Color> colors;
  final double outerPadding;

  const Box(
      {Key? key,
      required this.widget,
      this.fancy = false,
      this.colors = const [
        const Color(0xB48C2EA8),
        const Color(0xBE442FAC),
        const Color(0xB7CA42D4)
      ],
      this.outerPadding = 23.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.fancy)
      return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment(-1.09, -2.98),
            end: Alignment(1.0, 2.66),
            colors: colors,
            stops: [0.0, 0.468, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadowColor,
              offset: Offset(0, 4.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(this.outerPadding),
          child: widget,
        ),
      );
    else
      return Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Theme.of(context).colorScheme.lightDarkAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 3.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: widget,
          ),
        ),
      );
  }
}
