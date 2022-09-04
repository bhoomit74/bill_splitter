import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

Color primaryColor = MyColor.black_800;

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: GoogleFonts.montserrat().fontFamily);

TextStyle h1() {
  return TextStyle(
      color: primaryColor, fontWeight: FontWeight.w900, fontSize: 40);
}

TextStyle h2Light() {
  return TextStyle(
      color: primaryColor, fontWeight: FontWeight.w400, fontSize: 32);
}

TextStyle h2() {
  return TextStyle(
      color: primaryColor, fontWeight: FontWeight.w700, fontSize: 32);
}

TextStyle h3Bold({double? fontSize, Color? color}) {
  return TextStyle(
      color: color ?? primaryColor,
      fontWeight: FontWeight.w700,
      fontSize: fontSize ?? 24);
}

TextStyle h3_20({Color? color}) {
  return TextStyle(
      color: color ?? primaryColor, fontWeight: FontWeight.w600, fontSize: 20);
}

TextStyle h3_16({Color? color}) {
  return TextStyle(
      color: color ?? primaryColor, fontWeight: FontWeight.w600, fontSize: 16);
}

TextStyle h3Light({double? fontSize, Color? color}) {
  return TextStyle(
      color: color ?? primaryColor,
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? 24);
}

TextStyle h4() {
  return TextStyle(
      color: primaryColor.withAlpha(95),
      fontWeight: FontWeight.w400,
      fontSize: 18);
}

TextStyle h4Light() {
  return TextStyle(
      color: primaryColor.withAlpha(95),
      fontWeight: FontWeight.w300,
      fontSize: 18);
}

TextStyle h4Bold() {
  return TextStyle(
      color: primaryColor, fontWeight: FontWeight.w700, fontSize: 18);
}

TextStyle h5() {
  return TextStyle(
      color: primaryColor.withAlpha(95),
      fontWeight: FontWeight.w300,
      fontSize: 16);
}

TextStyle buttonTextStyle() {
  return TextStyle(
      color: MyColor.white, fontWeight: FontWeight.w500, fontSize: 14);
}

TextStyle buttonSmallTextStyle() {
  return TextStyle(
      color: MyColor.black_800, fontWeight: FontWeight.w600, fontSize: 14);
}
