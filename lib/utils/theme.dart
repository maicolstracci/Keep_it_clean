import 'package:flutter/material.dart';

class KeepItCleanTheme {
  static const Color _backgroundColor = Color(0xff06442d);
  static const Color _primaryGreen = Color(0xff1e5540);
  static const Color _accentColor = Color(0xfff4f8f9);
  static const String _fontFamily = "Montserrat";

  ThemeData get theme => ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: _backgroundColor,
        primaryColor: _primaryGreen,
        accentColor: _accentColor,
        fontFamily: _fontFamily,
        buttonColor: Colors.blue[800],
        textTheme: TextTheme(
          bodyText2: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w100,
              color: Colors.black87),
        ),
      );
}
