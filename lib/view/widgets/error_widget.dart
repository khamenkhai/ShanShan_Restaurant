import 'package:flutter/material.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/const/const_export.dart';

// ignore: must_be_immutable
class CustomErrorWidget extends StatelessWidget {
  CustomErrorWidget({super.key, required this.onPressed});

  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 60,
          color: AppColors.secondaryColor,
        ),
        SizedBox(height: 15),
        Text("Something went wrong"),
        SizedBox(height: 15),
        Center(
          child: CustomElevatedButton(
            bgColor: AppColors.secondaryColor,
            onPressed: onPressed,
            child: Text("Try Again"),
          ),
        ),
        SizedBox(height: 60),
      ],
    );
  }
}
