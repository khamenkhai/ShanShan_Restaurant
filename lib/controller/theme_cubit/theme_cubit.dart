import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/core/const/theme_const.dart';
import 'package:shan_shan/core/local_data/shared_prefs.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPref sharedPref;
  ThemeData? _cachedLightTheme;
  ThemeData? _cachedDarkTheme;

  ThemeCubit({required this.sharedPref})
      : super(ThemeState(theme: ThemeConstants.lightTheme(fontFamily: "Outfit"))) {
    _loadTheme();
  }

  // Load the theme and cache it
  Future<void> _loadTheme() async {
    String savedTheme = await sharedPref.getTheme();
    if (savedTheme == "dark") {
      _cachedDarkTheme ??= ThemeConstants.darkTheme(fontFamily: "Outfit");
      emit(ThemeState(theme: _cachedDarkTheme!));
    } else {
      _cachedLightTheme ??= ThemeConstants.lightTheme(fontFamily: "Outfit");
      emit(ThemeState(theme: _cachedLightTheme!));
    }
  }

  // Save theme and change theme with caching
  void toggleTheme() async {
    final currentTheme = state.theme;
    String newTheme;
    if (currentTheme.brightness == Brightness.light) {
      _cachedDarkTheme ??= ThemeConstants.darkTheme(fontFamily: "Outfit");
      emit(ThemeState(theme: _cachedDarkTheme!));
      newTheme = "dark";
    } else {
      _cachedLightTheme ??= ThemeConstants.lightTheme(fontFamily: "Outfit");
      emit(ThemeState(theme: _cachedLightTheme!));
      newTheme = "light";
    }

    await sharedPref.setTheme(newTheme);
  }
}
