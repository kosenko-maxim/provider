import 'package:flutter/material.dart';

const Color ACTIVE_COLOR = Color(0xDD000000);
const Color DISABLED_COLOR = Color(0x89000000);

const TextTheme customTextTheme = TextTheme(
  title: TextStyle(
    fontSize: 20.0,
    color: ACTIVE_COLOR,
  ),
  subhead: TextStyle(
    fontSize: 16.0,
    color: ACTIVE_COLOR,
  ),
  body1: TextStyle(
    fontSize: 14.0,
    color: DISABLED_COLOR,
  ),
  body2: TextStyle(
    fontSize: 14.0,
    color: ACTIVE_COLOR,
  ),
  caption: TextStyle(
    fontSize: 12.0,
    color: ACTIVE_COLOR,
  ),
  button: TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  ),
);
