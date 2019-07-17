import 'package:flutter/material.dart';

const int primaryValue = 0xFF37B4BC;
const MaterialColor primaryColor = MaterialColor(
  primaryValue,
  <int, Color>{
    50: Color(0xFFE7F6F7),
    100: Color(0xFFC3E9EB),
    200: Color(0xFF9BDADE),
    300: Color(0xFF73CBD0),
    400: Color(0xFF55BFC6),
    500: Color(primaryValue),
    600: Color(0xFF31ADB6),
    700: Color(0xFF2AA4AD),
    800: Color(0xFF239CA5),
    900: Color(0xFF168C97),
  },
);

const int accentPrimaryValue = 0xFF98F6FF;
const MaterialAccentColor accentColor = MaterialAccentColor(
  accentPrimaryValue,
  <int, Color>{
    100: Color(0xFFCBFBFF),
    200: Color(accentPrimaryValue),
    400: Color(0xFF65F2FF),
    700: Color(0xFF4CEFFF),
  },
);
