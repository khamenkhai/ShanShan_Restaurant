import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/core/const/theme_const.dart';
import 'package:shan_shan/core/local_data/shared_prefs.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPref sharedPref;
  ThemeData? _cachedLightTheme;
  ThemeData? _cachedDarkTheme;
  Color? _customPrimaryColor;

  ThemeCubit({required this.sharedPref})
      : super(ThemeState(theme: ThemeConstants.lightTheme(fontFamily: "Outfit"), isDarkMode: false)) {
    _loadTheme();
  }

  // Load the theme and cache it
  Future<void> _loadTheme() async {
    String savedTheme = await sharedPref.getTheme();
    String? savedColor = await sharedPref.getThemeColor();
    
    // Parse saved color if exists
    if (savedColor != null) {
      _customPrimaryColor = Color(int.parse(savedColor));
    }

    if (savedTheme == "dark") {
      _cachedDarkTheme = _buildDarkTheme(_customPrimaryColor);
      emit(ThemeState(
        theme: _cachedDarkTheme!,
        primaryColor: _customPrimaryColor,
        isDarkMode: true,
      ));
    } else {
      _cachedLightTheme = _buildLightTheme(_customPrimaryColor);
      emit(ThemeState(
        theme: _cachedLightTheme!,
        primaryColor: _customPrimaryColor,
        isDarkMode: false,
      ));
    }
  }

  // Toggle between light and dark mode
  void toggleTheme() async {
    final currentTheme = state.theme;
    String newTheme;
    
    if (currentTheme.brightness == Brightness.light) {
      _cachedDarkTheme = _buildDarkTheme(state.primaryColor);
      emit(ThemeState(
        theme: _cachedDarkTheme!,
        primaryColor: state.primaryColor,
        isDarkMode: true,
      ));
      newTheme = "dark";
    } else {
      _cachedLightTheme = _buildLightTheme(state.primaryColor);
      emit(ThemeState(
        theme: _cachedLightTheme!,
        primaryColor: state.primaryColor,
        isDarkMode: false,
      ));
      newTheme = "light";
    }

    await sharedPref.setTheme(newTheme);
  }

  // Change primary color
  void changePrimaryColor(Color color) async {
    _customPrimaryColor = color;
    
    if (state.isDarkMode) {
      _cachedDarkTheme = _buildDarkTheme(color);
      emit(ThemeState(
        theme: _cachedDarkTheme!,
        primaryColor: color,
        isDarkMode: true,
      ));
    } else {
      _cachedLightTheme = _buildLightTheme(color);
      emit(ThemeState(
        theme: _cachedLightTheme!,
        primaryColor: color,
        isDarkMode: false,
      ));
    }
    
    await sharedPref.setThemeColor(color.value.toString());
  }

  // Helper methods to build themes with custom colors
  ThemeData _buildLightTheme(Color? primaryColor) {
    return ThemeConstants.lightTheme(
      fontFamily: "Outfit",
      primaryColor: primaryColor,
    );
  }

  ThemeData _buildDarkTheme(Color? primaryColor) {
    return ThemeConstants.darkTheme(
      fontFamily: "Outfit",
      primaryColor: primaryColor,
    );
  }
}