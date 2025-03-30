import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

///delete category warning dialog box
Future<dynamic> deleteWarningDialog({
  required BuildContext context,
  required Size screenSize,
  required Widget child,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: SizeConst.kBorderRadius,
        ),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20),
          width: screenSize.width / 3.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text(
                "ဖျက်ရန် သေချာလား",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              child
            ],
          ),
        ),
      );
    },
  );
}
