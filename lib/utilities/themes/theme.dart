import 'package:flutter/material.dart';
import 'package:smart_fin/utilities/themes/custom_themes/appbar_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/bottom_sheet.dart';
import 'package:smart_fin/utilities/themes/custom_themes/checkbox_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/chip_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/elevated_button_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/outlined_button_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/text_form_field_theme.dart';
import 'package:smart_fin/utilities/themes/custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();
  static final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    // textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    // primaryTextTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  );

  static final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    // primaryColor: Colors.white,
    // textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    // primaryTextTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
  );

  static final ThemeData _lightTheme = ThemeData(
    // fontFamily: "",
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
    ),
    primaryColor: const Color(0xFF6200EE),
    textTheme: CustomTextTheme.lightTextTheme,
    chipTheme: CustomChipTheme.lightChipTheme,
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),
    appBarTheme: CustomAppBarTheme.lightAppbarTheme,
    checkboxTheme: CustomCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: CustomBottomSheet.lightBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.lightInputDecorationTheme,
  );

  static final ThemeData _darkTheme = ThemeData(
    // fontFamily: "",
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: Colors.grey,
    ),
    primaryColor: const Color(0xFF6200EE),
    textTheme: CustomTextTheme.darkTextTheme,
    chipTheme: CustomChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: CustomAppBarTheme.darkAppbarTheme,
    checkboxTheme: CustomCheckBoxTheme.darkCheckBoxTheme,
    bottomSheetTheme: CustomBottomSheet.darkBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.darkInputDecorationTheme,
  );
}
