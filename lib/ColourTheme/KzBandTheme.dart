import 'package:flutter/material.dart';

//Application colour theme
class KzBandTheme {
  static const Color background = Color(0xFF060E13);
  static const Color panel = Color(0xFF0D1B24);
  static const Color accent = Color(0xFF4FA8FF);
}

final ThemeData kzBandTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: KzBandTheme.background,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  cardColor: KzBandTheme.panel,
  colorScheme: ColorScheme.dark(
    primary: KzBandTheme.accent,
    background: KzBandTheme.background,
  ),
);