import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primary = Color.fromRGBO(0, 186, 195, 1);
const _primaryDark = Color.fromRGBO(25, 154, 151, 1);
const _canvas = Color.fromRGBO(5, 49, 57, 1);

/// Dark elevated surface used where the app historically used `primaryColorLight`
/// (cards, dialogs). Must stay dark so light `textTheme` stays readable.
const _surfaceCard = Color.fromRGBO(22, 72, 78, 1);

final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
  seedColor: _primary,
  brightness: Brightness.dark,
).copyWith(
  surface: _canvas,
  surfaceContainerLowest: const Color.fromRGBO(4, 40, 47, 1),
  surfaceContainerLow: const Color.fromRGBO(12, 55, 62, 1),
  surfaceContainer: const Color.fromRGBO(16, 62, 68, 1),
  surfaceContainerHigh: _surfaceCard,
  surfaceContainerHighest: const Color.fromRGBO(32, 88, 94, 1),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkColorScheme,
  scaffoldBackgroundColor: Colors.transparent,
  brightness: Brightness.dark,
  primaryColor: _primary,
  primaryColorDark: _primaryDark,
  primaryColorLight: _surfaceCard,
  canvasColor: _canvas,
  highlightColor: _canvas,
  hintColor: _primary,
  cardColor: _darkColorScheme.surfaceContainerHigh,
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(
      width: 1,
      style: BorderStyle.solid,
      color: _darkColorScheme.outline,
      strokeAlign: BorderSide.strokeAlignOutside,
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    fillColor: const WidgetStatePropertyAll(Colors.transparent),
    visualDensity: VisualDensity.compact,
    overlayColor: const WidgetStatePropertyAll(Colors.white38),
    checkColor: const WidgetStatePropertyAll(Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    toolbarHeight: 40,
    actionsIconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
    shadowColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: _darkColorScheme.surfaceContainer,
    selectedItemColor: _primary,
    unselectedItemColor: _darkColorScheme.onSurfaceVariant,
    elevation: 10,
    selectedIconTheme: const IconThemeData(size: 30),
    unselectedIconTheme: const IconThemeData(size: 25),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _primary,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: _primary,
    linearTrackColor: _darkColorScheme.surfaceContainerHighest,
    circularTrackColor: _darkColorScheme.surfaceContainerHighest,
  ),
  tabBarTheme: TabBarThemeData(
    splashFactory: NoSplash.splashFactory,
    labelColor: _darkColorScheme.onPrimary,
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: _darkColorScheme.onPrimary,
    ),
    unselectedLabelColor: _darkColorScheme.onSurfaceVariant,
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    indicator: BoxDecoration(
      color: _darkColorScheme.primary,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
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
      borderSide: const BorderSide(width: 2, color: Color.fromRGBO(30, 188, 183, 1)),
    ),
    filled: true,
    fillColor: _darkColorScheme.surfaceContainerHigh,
    errorStyle: const TextStyle(
        fontSize: 14, color: Colors.red, fontWeight: FontWeight.w300),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    floatingLabelAlignment: FloatingLabelAlignment.start,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    hintStyle: TextStyle(
      fontSize: 14,
      color: _darkColorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w300,
    ),
    border: OutlineInputBorder(
      gapPadding: 10,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStatePropertyAll(Colors.white12),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(
      fontSize: 20,
      color: Colors.white,
      height: 2,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: const TextStyle(fontSize: 18, color: Colors.white),
    bodySmall: const TextStyle(fontSize: 14, color: Colors.white),
    labelMedium: TextStyle(
      fontSize: 16,
      color: _darkColorScheme.onSurface,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      color: _darkColorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w300,
    ),
    displayMedium: const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      color: _darkColorScheme.onSurface,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      color: _darkColorScheme.onSurface,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      color: _darkColorScheme.onSurface,
      fontWeight: FontWeight.w600,
    ),
  ),
);
