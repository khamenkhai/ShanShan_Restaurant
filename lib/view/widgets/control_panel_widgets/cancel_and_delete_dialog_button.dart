import 'package:flutter/material.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

class CancelAndDeleteDialogButton extends StatelessWidget {
  const CancelAndDeleteDialogButton({super.key, required this.onDelete});
  final Future Function() onDelete;

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
          bgColor: Colors.red,
          child: Text("ဖျက်မည်"),
          onPressed: () async {
            await onDelete();
            print("testing delete");
          },
        ),
      ],
    );
  }
}
