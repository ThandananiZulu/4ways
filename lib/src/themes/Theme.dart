import 'package:flutter/material.dart';

ThemeData MyTheme() {
  return ThemeData(
    primaryColor: Color(0xff1777F0),
    primaryColorDark: Color(0xff023D87),
    primaryColorLight: Color(0xffE6F1FF),
    backgroundColor: Color(0xffCCCFD5),
    scaffoldBackgroundColor: Colors.white,
    highlightColor: Color(0xffE7F0FE),
    textTheme: TextTheme(
      subtitle1: TextStyle(
        color: Color(0xff1D1E22),
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      headline6: TextStyle( // Use headline6 instead of subhead
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    fontFamily: 'Helvetica Neue',
    dividerColor: Color(0xffCCCFD5),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xffEFF5F5)),
  );
}
