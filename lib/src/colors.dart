import 'package:flutter/material.dart';

//import '../colors.dart';
//Theme.of(context).colorScheme.lightDarkAccent

extension ColorsDefined on ColorScheme {
  Color get white =>
      brightness == Brightness.light ? Colors.white : Colors.black;
  Color get black =>
      brightness == Brightness.light ? Colors.black : Colors.white;
  Color get purpleText => brightness == Brightness.light
      ? const Color(0xFF824FD4)
      : const Color(0xFFCB94DB);
  Color get lightDarkAccent => brightness == Brightness.light
      ? const Color(0xFFFAFAFA)
      : const Color(0xFF3B3B3B);
  Color get shadowColor => brightness == Brightness.light
      ? const Color(0x655A5A5A)
      : const Color(0x69BDBDBD);
  Color get shadowColorLight => brightness == Brightness.light
      ? const Color(0x2D5A5A5A)
      : const Color(0x4BBDBDBD);
  Color get purpleAccent => brightness == Brightness.light
      ? const Color(0xFF6f1e88)
      : const Color(0xFF6f1e88);
  Color get lightPurpleAccent => brightness == Brightness.light
      ? const Color(0xFF936DCF)
      : const Color(0xFF864899);
  Color get lightLightPurpleAccent => brightness == Brightness.light
      ? const Color(0xFF8F7DAC)
      : const Color(0xFF886B91);
  Color get mainIconBackground => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFFE7E7E7);
  Color get yellowAccent => brightness == Brightness.light
      ? const Color(0xFFF1BD2C)
      : const Color(0xFFDBAF50);
  Color get redAccent => brightness == Brightness.light
      ? const Color(0xFFB42B22)
      : const Color(0xFFF06E6E);
}
