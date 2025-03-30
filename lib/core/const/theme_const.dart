import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shan_shan/core/const/color_const.dart';

@immutable
class ThemeConstants {
  // Common styles and themes (all const to reduce runtime overhead)
  static const SystemUiOverlayStyle _systemOverlayStyle = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  );

  static const TextStyle _appBarTitleTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _bodyMediumTextStyle = TextStyle(fontSize: 16);

  static const IconThemeData _iconTheme = IconThemeData(
    color: ColorConstants.primaryColor,
  );

  static const SwitchThemeData _switchTheme = SwitchThemeData(
    splashRadius: 10,
  );

  static const BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    selectedItemColor: ColorConstants.primaryColor,
  );

  /// Light theme (cached for better performance)
  static ThemeData lightTheme({required String fontFamily}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ColorConstants.primaryColor,
        secondary: ColorConstants.secondaryColor,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: _systemOverlayStyle,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: ColorConstants.primaryColor,
        titleTextStyle: _appBarTitleTextStyle.copyWith(fontFamily: fontFamily),
        centerTitle: false,
      ),
      textTheme: const TextTheme(bodyMedium: _bodyMediumTextStyle),
      fontFamily: fontFamily,
      scaffoldBackgroundColor: ColorConstants.backgroundColorLight,
      switchTheme: _switchTheme,
      iconTheme: _iconTheme,
      dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
    );
  }

  /// Dark theme (cached for better performance)
  static ThemeData darkTheme({required String fontFamily}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ColorConstants.primaryColor,
        secondary: ColorConstants.secondaryColor,
        // surface: ColorConstants.customColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: _systemOverlayStyle,
        backgroundColor: ColorConstants.primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: _appBarTitleTextStyle.copyWith(fontFamily: fontFamily),
        centerTitle: false,
      ),
      textTheme: const TextTheme(bodyMedium: _bodyMediumTextStyle),
      fontFamily: fontFamily,
      scaffoldBackgroundColor: ColorConstants.backgroundColorDark,
      switchTheme: _switchTheme,
      iconTheme: _iconTheme,
      iconButtonTheme: const IconButtonThemeData(style: ButtonStyle()),
      dialogTheme: const DialogTheme(
        backgroundColor: ColorConstants.backgroundColorDark,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: ColorConstants.backgroundColorDark,
      ),
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
    );
  }
}