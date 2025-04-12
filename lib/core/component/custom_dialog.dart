import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
   CustomDialog({
    super.key,
    required this.child,
    this.width,
    this.paddingInVertical = true,
  });
  final Widget child;
  final double? width;
  bool paddingInVertical;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical:paddingInVertical ? 15 : 0,
          horizontal: 15,
        ),
        width: width ?? size.width / 3.8,
        child: child,
      ),
    );
  }
}
