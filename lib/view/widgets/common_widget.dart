import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shimmer/shimmer.dart';

InputDecoration customTextDecoration({
  String labelText = "",
  String hintText = "",
  Widget? prefixIcon,
  Widget? suffixIcon,
  //Widget? prefixWidget,
  double fontSize = 14,
  Color? labelColor,
  Color? hintColor,
  bool floatLabel = false,
}) {
  return InputDecoration(
    labelText: "$labelText",
    labelStyle: TextStyle(
      color: labelColor ?? ColorConstants.greyColor,
      fontSize: fontSize,
    ),
    floatingLabelBehavior:
        floatLabel ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
    prefixIcon: prefixIcon ?? Container(),
    suffixIcon: suffixIcon ??
        Icon(
          Icons.abc,
          color: Colors.transparent,
        ),
    //prefixIcon: prefixWidget ?? Container(),
    border: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 0.5,
        color: ColorConstants.greyColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 0.5,
        color: ColorConstants.greyColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 1,
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 1,
        color: ColorConstants.primaryColor,
      ),
    ),
    filled: true,
    fillColor: Colors.white,
    focusColor: ColorConstants.greyColor,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 0,
    ),
  );
}

InputDecoration customTextDecoration2(
    {String labelText = "",
    String hintText = "",
    double fontSize = 14,
    Color? labelColor,
    Color? hintColor,
    bool floatLabel = false,
    double verticalPadding = 0}) {
  return InputDecoration(
    labelText: "$labelText",
    labelStyle: TextStyle(
      color: labelColor ?? ColorConstants.greyColor,
      fontSize: fontSize,
    ),
    floatingLabelBehavior:
        floatLabel ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 0.5,
        color: ColorConstants.greyColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 0.5,
        color: ColorConstants.greyColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 0.5,
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: 1,
        color: ColorConstants.primaryColor,
      ),
    ),
    filled: true,
    fillColor: Colors.white,
    focusColor: ColorConstants.greyColor,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 15,
      vertical: verticalPadding,
    ),
  );
}

///custumizable elevated button
// Container CustomElevatedButton({
//   Color fgColor = Colors.white,
//   Color? bgColor,
//   required Widget child,
//   double width = 100,
//   double radius = 15,
//   double height = 45,
//   double elevation = 0,
//   required Function() onPressed,
//   double fontSize = 16,
//   bool enabled = true,
// }) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 5),
//     //width: width,
//     height: height,
//     constraints: BoxConstraints(minWidth: width),
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize),
//         elevation: elevation,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: SizeConst.kBorderRadius,
//         ),
//         backgroundColor: bgColor == null ? ColorConstants.primaryColor : bgColor,
//       ),
//       onPressed: enabled ? onPressed : null,
//       child: child,
//     ),
//   );
// }

///shimmer loading widget
Shimmer categoryShimmer({double height = 35}) {
  return Shimmer.fromColors(
    baseColor: Colors.white,
    // ignore: deprecated_member_use
    highlightColor: Colors.grey.shade300.withOpacity(0.5),
    child: Container(
      //margin: EdgeInsets.only(right: 15),
      constraints: BoxConstraints(
        minWidth: 170,
        minHeight: height,
      ),
      padding: EdgeInsets.only(
        top: 1,
        bottom: 1,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: Center(
        child: Text(
          "testing",
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
    ),
  );
}

///appbar leading
InkWell appBarLeading({required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: SizeConst.kHorizontalPadding),
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            padding: EdgeInsets.only(
              left: 13,
              right: 13,
              top: 5,
              bottom: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: Center(
              child: Icon(
                IconlyBold.arrow_left_2,
                // size: 15,
              ),
            ),
          ),
        ),
        // SizedBox(width: 5),
        // Text(
        //   "${tr(LocaleKeys.lblBack)}",
        //   style: TextStyle(
        //     color: ColorConstants.primaryColor,
        //     fontWeight: FontWeight.normal,
        //   ),
        // )
      ],
    ),
  );
}

///locading Circle widget
// Widget LoadingWidget({
//   Color? color,
//   double? size,
//   double? height,
// }) {
//   return Center(
//     //child: CircularProgressIndicator(),
//     child: SpinKitFadingCircle(
//       color: ColorConstants.primaryColor,
//       size: 50.0,
//     ),
//   );
// }

Widget copyRightWidget() {
  return Container(
    width: double.infinity,
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 40),
        Text(
          "Copyright © 2024 - ${DateFormat('y').format(DateTime.now())} TermsFeed®. All rights reserved.",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(width: 10),
        Row(
          children: [
            Text(
              "Developed By",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              " Softnovations",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(width: 30),
      ],
    ),
  );
}


// ///locading Circle widget
// Widget loadingDots({
//   Color? color,
//   double? size,
//   double? height,
// }) {
//   return Center(
//     child: Image.asset(
      
//       height: height == null ? 80 : height,
//       fit: BoxFit.contain,
//     ),
//   );
// }
