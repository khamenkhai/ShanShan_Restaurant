import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

class DateActionWidget extends StatelessWidget {
  const DateActionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E d, MMM yyyy').format(DateTime.now()),
              style: TextStyle(
                color: ColorConstants.primaryColor,
                fontSize: 20 - 4,
              ),
            ),
            SizedBox(width: 10),
            Icon(CupertinoIcons.calendar)
          ],
        ),
      ),
    );
  }
}
