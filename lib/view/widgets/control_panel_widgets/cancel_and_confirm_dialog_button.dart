import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

class CancelAndConfirmDialogButton extends StatelessWidget {
  const CancelAndConfirmDialogButton({super.key, required this.onConfirm});
  final Future Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        customizableOTButton(
          elevation: 0,
          child: Text("ပယ်ဖျက်ရန်"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 10),
        custamizableElevated(
          bgColor: ColorConstants.primaryColor,
          child: Text("အတည်ပြုရန်"),
          onPressed: () async {
            await onConfirm();
            print("testing bbb");
          },
        ),
      ],
    );
  }
}
