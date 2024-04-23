import 'package:flutter/material.dart';
import 'package:smart_fin/utilities/themes/custom_themes/default_theme/appbar_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/default_theme/elevated_button_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/default_theme/outlined_button_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/default_theme/text_form_field_theme.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/appbar_theme.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/bottom_sheet.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/checkbox_theme.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/chip_theme.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/elevated_button_theme.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/outlined_button_theme.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/text_form_field_theme.dart';
// import 'package:smart_fin/utilities/themes/custom_themes_/text_theme.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Color(0xFF314cb6),
      secondary: Color(0xFF00916E),
    ),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.lightInputDecorationTheme,
    appBarTheme: CustomAppBarTheme.lightAppbarTheme,
  );

  // static final ThemeData __darkTheme = ThemeData(
  //   // fontFamily: "",
  //   brightness: Brightness.dark,
  //   colorScheme: const ColorScheme.dark(
  //     background: Colors.grey,
  //   ),
  //   primaryColor: const Color(0xFF6200EE),
  //   textTheme: CustomTextTheme.darkTextTheme,
  //   chipTheme: CustomChipTheme.darkChipTheme,
  //   scaffoldBackgroundColor: Colors.black,
  //   appBarTheme: CustomAppBarTheme.darkAppbarTheme,
  //   checkboxTheme: CustomCheckBoxTheme.darkCheckBoxTheme,
  //   bottomSheetTheme: CustomBottomSheet.darkBottomSheetTheme,
  //   elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme,
  //   outlinedButtonTheme: CustomOutlinedButtonTheme.darkOutlinedButtonTheme,
  //   inputDecorationTheme: CustomTextFormFieldTheme.darkInputDecorationTheme,
  // );
}
