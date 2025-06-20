import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

class AppInputDecoration {
  static InputDecoration basic({
    String labelText = "",
    String hintText = "",
    Widget? prefixIcon,
    Widget? suffixIcon,
    double fontSize = 14,
    Color? labelColor,
    Color? hintColor,
    bool floatLabel = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: labelColor ?? AppColors.greyColor,
        fontSize: fontSize,
      ),
      floatingLabelBehavior:
          floatLabel ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        color: hintColor ?? Colors.grey,
      ),
      prefixIcon: prefixIcon ?? const SizedBox(),
      suffixIcon: suffixIcon ??
          const Icon(
            Icons.abc,
            color: Colors.transparent,
          ),
      border: OutlineInputBorder(
        borderRadius: SizeConst.kBorderRadius,
        borderSide: BorderSide(
          width: 0.5,
          color: AppColors.greyColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: SizeConst.kBorderRadius,
        borderSide: BorderSide(
          width: 0.5,
          color: AppColors.greyColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: SizeConst.kBorderRadius,
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: SizeConst.kBorderRadius,
        borderSide: BorderSide(
          width: 1,
          color: AppColors.primaryColor,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      focusColor: AppColors.greyColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 0,
      ),
    );
  }
}

