import 'package:flutter/material.dart';

class CustomAppBarTheme {
  CustomAppBarTheme._();

  static const AppBarTheme lightAppbarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size: 24),
    actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
    titleTextStyle: TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
  );

  static const AppBarTheme darkAppbarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size: 24),
    actionsIconTheme: IconThemeData(color: Colors.white, size: 24),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
  );
}
