import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';

class CancelAndDeleteDialogButton extends StatelessWidget {
  const CancelAndDeleteDialogButton({super.key, required this.onDelete});
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomOutlineButton(
          elevation: 0,
          child: Text(tr(LocaleKeys.cancel)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 10),
        CustomElevatedButton(
          bgColor: Colors.red,
          onPressed: onDelete,
          child: Text(tr(LocaleKeys.delete)),
        ),
      ],
    );
  }
}
