import 'package:flutter/material.dart';
import 'package:frosh_week_2t1/src/widgets/Containers.dart';

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
  Color get darkPurpleAccent => brightness == Brightness.light
      ? const Color(0xFF5A4B72)
      : const Color(0xFFF7DDFF);
  Color get mainIconBackground => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFFE7E7E7);
  Color get yellowAccent => brightness == Brightness.light
      ? const Color(0xFFF1BD2C)
      : const Color(0xFFDBAF50);
  Color get redAccent => brightness == Brightness.light
      ? const Color(0xFFB42B22)
      : const Color(0xFFF06E6E);
  Color get greenAccent => brightness == Brightness.light
      ? const Color(0xFF69B315)
      : const Color(0xFF79C54D);
  Color get qrColor => brightness == Brightness.light //needs high contrast
      ? const Color(0xFF380077)
      : const Color(0xFF310069);
  Color get qrBackground => brightness == Brightness.light //needs high contrast
      ? const Color(0xFFF5F5F5)
      : const Color(0xFFE6E6E6);
  Color get animatedBackground =>
      brightness == Brightness.light //needs high contrast
          ? const Color(0xFF8962D3)
          : const Color(0xFF3A1D5F);
  Color get animatedBubbles =>
      brightness == Brightness.light //needs high contrast
          ? const Color(0xC778728D)
          : const Color(0xDE9F67A1);
}
