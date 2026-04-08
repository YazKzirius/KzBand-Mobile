import 'package:flutter/material.dart';

const Color bgColor = Color(0xFF060E13);

ThemeData kzBandTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: bgColor,
  useMaterial3: true,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  ),
);
