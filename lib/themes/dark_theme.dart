import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    brightness: Brightness.dark,
    primaryColor: const Color.fromRGBO(30, 188, 183, 1),
    primaryColorDark: const Color.fromRGBO(25, 154, 151, 1),
    primaryColorLight: const Color.fromRGBO(227, 255, 254, 1),
    canvasColor: const Color.fromRGBO(5, 49, 57, 1),
    highlightColor:  const Color.fromRGBO(5, 49, 57, 1),
    hintColor:const Color.fromRGBO(227, 255, 254, 1) ,
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: Colors.black,
          strokeAlign: BorderSide.strokeAlignOutside),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: MaterialStatePropertyAll(Colors.transparent),
      visualDensity: VisualDensity.compact,
      overlayColor: MaterialStatePropertyAll(Colors.white38),
      checkColor: MaterialStatePropertyAll(Colors.white),
    ),
    cardColor: Colors.white,
    indicatorColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: 40,
      actionsIconTheme: IconThemeData(color: Colors.white),
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
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: OutlineInputBorder(
        gapPadding: 10,
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(width: 2, color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 10,
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(width: 2, color: Color.fromRGBO(30, 188, 183, 1)),
      ),
      filled: true,
      fillColor: const Color.fromRGBO(227, 255, 254, 1),
      errorStyle: const TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.w300),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      hintStyle: const TextStyle(
          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
      border: OutlineInputBorder(
          gapPadding: 10,
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none),
    ),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.white12))),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
      bodySmall: TextStyle(fontSize: 14, color: Colors.white),
      labelMedium: TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(
          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
      displaySmall: TextStyle(
          fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
    ));
