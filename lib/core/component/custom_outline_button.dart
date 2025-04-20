import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

class CustomOutlineButton extends StatelessWidget {
  final Color? fgColor;
  final Color? bgColor;
  final Widget child;
  final double width;
  final double? radius;
  final double height;
  final double elevation;
  final VoidCallback onPressed;

  const CustomOutlineButton({
    super.key,
    this.fgColor,
    this.bgColor,
    required this.child,
    this.width = 100,
    this.radius,
    this.height = 45,
    this.elevation = 0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      constraints: BoxConstraints(minWidth: width, minHeight: height),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: elevation,
          foregroundColor: fgColor ?? ColorConstants.greyColor,
          backgroundColor: bgColor ?? Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: SizeConst.kBorderRadius,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
