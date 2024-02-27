import 'package:flutter/material.dart';

final baseTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
      // elevation: 10,
      // shadowColor: Colors.black54,
      iconTheme: IconThemeData(
        color: Colors.teal, //change your color here
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        elevation: 10,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 25)),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.teal));
