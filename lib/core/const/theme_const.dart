// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shan_shan/core/const/color_const.dart';

@immutable
class ThemeConstants {
  // Common styles and themes (all const to reduce runtime overhead)
  static const SystemUiOverlayStyle _lightSystemOverlayStyle =
      SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  );

  static const SystemUiOverlayStyle _darkSystemOverlayStyle =
      SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  );

  static TextStyle _appBarTitleTextStyle(Color color) => TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  static const TextStyle _bodyMediumTextStyle = TextStyle(fontSize: 16);

  static SwitchThemeData _switchTheme(Color primaryColor) => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.5);
        }),
        splashRadius: 10,
      );

  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
          Color primaryColor) =>
      BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      );

  static BottomNavigationBarThemeData _darkBottomNavigationBarTheme(
          Color primaryColor) =>
      BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400]!,
        backgroundColor: ColorConstants.backgroundColorDark,
      );

  /// Light theme
  static ThemeData lightTheme({
    required String fontFamily,
    Color? primaryColor,
  }) {
    final color = primaryColor ?? ColorConstants.primaryColor;
    final onPrimary =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: color,
      colorScheme: ColorScheme.light(
        primary: color,
        onPrimary: onPrimary,
        secondary: color.withOpacity(0.8),
        surface: Colors.white,
        background: ColorConstants.backgroundColorLight,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: _lightSystemOverlayStyle,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: color,
        titleTextStyle: _appBarTitleTextStyle(Colors.black)
            .copyWith(fontFamily: fontFamily),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: color),
      ),
      textTheme: TextTheme(
        bodyMedium: _bodyMediumTextStyle.copyWith(color: Colors.black87),
        titleMedium:
            TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(color: Colors.white), // For buttons
      ),
      scaffoldBackgroundColor: ColorConstants.backgroundColorLight,
      switchTheme: _switchTheme(color),
      iconTheme: IconThemeData(color: color),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: Colors.black87),
      ),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(color),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: color,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: onPrimary,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardColor: ColorConstants.cardColorLight,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }

  /// Dark theme
  static ThemeData darkTheme({
    required String fontFamily,
    Color? primaryColor,
  }) {
    final color = primaryColor ?? Colors.blue;
    final onPrimary =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: color,
      colorScheme: ColorScheme.dark(
        primary: color,
        onPrimary: onPrimary,
        secondary: color.withOpacity(0.8),
        surface: ColorConstants.backgroundColorDark,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: _darkSystemOverlayStyle,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: _appBarTitleTextStyle(Colors.white)
            .copyWith(fontFamily: fontFamily),
        centerTitle: false,
        iconTheme: IconThemeData(color: color),
      ),
      textTheme: TextTheme(
        bodyMedium: _bodyMediumTextStyle.copyWith(
            color: Colors.white.withOpacity(0.87)),
        titleMedium:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(color: Colors.black), // For buttons
      ),
      scaffoldBackgroundColor: ColorConstants.backgroundColorDark,
      switchTheme: _switchTheme(color),
      iconTheme: IconThemeData(color: color),
      dialogTheme: DialogTheme(
        backgroundColor: ColorConstants.backgroundColorDark,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: Colors.white.withOpacity(0.87)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: ColorConstants.backgroundColorDark,
        textStyle: TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: _darkBottomNavigationBarTheme(color),
      cardTheme: CardTheme(
        color: ColorConstants.cardColorDark,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      cardColor: ColorConstants.cardColorDark,
      buttonTheme: ButtonThemeData(
        buttonColor: color,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: onPrimary,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade400),
        fillColor: ColorConstants.cardColorDark,
        filled: true,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
