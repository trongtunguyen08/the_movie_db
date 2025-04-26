import 'package:flutter/material.dart';
import 'package:tmdb/core/theme/app_pallete.dart';

class DbAppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color),
    borderRadius: BorderRadius.circular(10.0),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27.0),
      focusedBorder: _border(Pallete.gradient1),
      enabledBorder: _border(Pallete.borderColor),
    ),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.inactiveSeekColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27.0),
      focusedBorder: _border(Pallete.gradient1),
      enabledBorder: _border(Pallete.borderColor),
    ),
  );
}
