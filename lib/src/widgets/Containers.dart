import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final Widget widget;
  final bool fancy;

  const Box({
    Key? key,
    required this.widget,
    this.fancy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.fancy)
      return Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment(-1.09, -2.98),
                end: Alignment(1.0, 2.66),
                colors: [
                  const Color(0xFF8B2EA8).withOpacity(0.89),
                  const Color(0xFF432FAC).withOpacity(0.75),
                  const Color(0xFFCA42D4).withOpacity(0.48)
                ],
                stops: [0.0, 0.468, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  offset: Offset(0, 4.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: widget,
            ),
          ));
    else
      return Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white,
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
