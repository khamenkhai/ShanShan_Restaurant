import 'package:flutter/material.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/const/const_export.dart';

class CancelAndConfirmDialogButton extends StatelessWidget {
  const CancelAndConfirmDialogButton({super.key, required this.onConfirm});
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomOutlineButton(
          elevation: 0,
          child: Text("ပယ်ဖျက်ရန်"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 10),
        CustomElevatedButton(
          bgColor: ColorConstants.primaryColor,
          onPressed: onConfirm,
          child: Text("အတည်ပြုရန်"),
        ),
      ],
    );
  }
}
