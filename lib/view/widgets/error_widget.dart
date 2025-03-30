import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

// ignore: must_be_immutable
class CustomErrorWidget extends StatelessWidget {
  CustomErrorWidget({required this.onPressed});

  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 60,
          color: ColorConstants.secondaryColor,
        ),
        SizedBox(height: 15),
        Text("Something went wrong"),
        SizedBox(height: 15),
        Center(
          child: custamizableElevated(
            bgColor: ColorConstants.secondaryColor,
            child: Text("Try Again"),
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: 60),
      ],
    );
  }
}
