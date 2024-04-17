import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.transparent,
  primaryColor: const Color.fromRGBO(0, 186, 195, 1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    toolbarHeight: 40,
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
    // elevation: 10,
    shadowColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.teal,
      elevation: 10,
      selectedIconTheme: IconThemeData(size: 30),
      unselectedIconTheme: IconThemeData(size: 25)),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: Colors.teal),
  tabBarTheme: const TabBarTheme(
    splashFactory: NoSplash.splashFactory,
    labelColor: Colors.black,
    labelStyle: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
    unselectedLabelColor: Colors.white,
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    indicator: BoxDecoration(
        color: Color.fromRGBO(4, 49, 57, 1),
        borderRadius: BorderRadius.all(Radius.circular(8))),
    dividerColor: Colors.transparent,
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Colors.white12)
    )
  )
);
