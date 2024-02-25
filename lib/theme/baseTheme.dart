import 'package:flutter/material.dart';

final baseTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.teal,
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22),
    elevation: 10,
    shadowColor: Colors.black54,
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
  ),
);
