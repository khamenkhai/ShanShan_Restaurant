part of 'theme_cubit.dart';

@immutable
class ThemeState {
  final ThemeData theme;
  final Color? primaryColor;
  final bool isDarkMode;

  const ThemeState({
    required this.theme,
    this.primaryColor,
    required this.isDarkMode,
  });
}
