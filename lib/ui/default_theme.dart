import 'package:flutter/material.dart';

final defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  dividerColor: Colors.black38,
  textTheme: const TextTheme(
    labelLarge: TextStyle(
      color: Colors.black87,
      fontSize: 20,
    ),
    labelMedium: TextStyle(
      color: Colors.black87,
      fontSize: 14,
    ),
    labelSmall: TextStyle(
      color: Colors.black26,
      fontSize: 14,
    ),
  ),
);