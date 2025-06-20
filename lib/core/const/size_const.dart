import 'package:flutter/material.dart';

class SizeConst {
  /// Horizontal padding constant
  static const double kGlobalPadding = 16;

  static const double kGlobalMargin = 16;

  /// Vertical spacing constant
  static const double kVerticalSpacing = 16;

  static const double radius = 12;

  /// Border radius (this can't be `const` directly for dynamic radius)
  static const BorderRadius kBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );



  /// Icon size constant
  static const double kIconSize = 24;

  /// Box shadow (can't be `const` because the default values are dynamic)
  static const BoxShadow kBoxShadow = BoxShadow(
    blurRadius: 6.0,
    color: Color(0x29000000),
    offset: Offset(0, 4),
  );

  /// Height of app bar
  static const double kAppBarHeight = 56;

  /// Divider thickness constant
  static const double kDividerThickness = 1.0;
}
