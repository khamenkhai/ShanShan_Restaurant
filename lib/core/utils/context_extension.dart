import 'package:flutter/material.dart';

extension ThemeContextExtension on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get cardColor => Theme.of(this).cardColor;
}
