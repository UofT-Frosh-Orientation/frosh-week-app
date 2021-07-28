import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String text;
  final String textSmaller;
  final bool icon;

  const MainHeader(
      {Key? key,
      required this.text,
      required this.textSmaller,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icon = Padding(
      padding: const EdgeInsets.only(left: 15, right: 8),
      child: Container(
        alignment: Alignment(0, 0),
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(27, 27)),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorDark.withOpacity(0.16),
              offset: Offset(0, 3.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(19, 19)),
            image: DecorationImage(
              image: AssetImage('assets/images/main_logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
    if (!this.icon) {
      icon = Padding(
        padding: const EdgeInsets.only(
          left: 17,
        ),
        child: Container(),
      );
    }

    return Padding(
        padding: const EdgeInsets.only(top: 130.0, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: "$text ",
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "$textSmaller",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class Header extends StatelessWidget {
  final String text;
  final bool padding;

  const Header({Key? key, required this.text, this.padding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddingAmount = 0;
    if (this.padding) {
      paddingAmount = 14;
    }
    return Padding(
      padding: EdgeInsets.only(left: paddingAmount),
      child: TextFont(
        text: this.text,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TextFont extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const TextFont(
      {Key? key,
      required this.text,
      this.fontSize = 20,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: this.fontWeight,
          fontSize: this.fontSize,
          fontFamily: 'Avenir'),
    );
  }
}
