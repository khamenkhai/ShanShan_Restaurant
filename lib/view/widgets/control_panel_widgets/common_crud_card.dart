import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

Widget commonCrudCard({
  required String title,
  required String description,
  required Function() onEdit,
  required Function() onDelete,
}) {
  return Container(
    padding: EdgeInsets.only(
      top: SizeConst.kHorizontalPadding - 3,
      bottom: SizeConst.kHorizontalPadding - 3,
      left: 15,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Visibility(
              visible: description != "",
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    "${description}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16 - 3,
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Spacer(),
        Spacer(),
        InkWell(
          onTap: onEdit,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.edit,
              size: 20,
              color: Colors.blue,
            ),
          ),
        ),
        InkWell(
          onTap: onDelete,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Icon(
              CupertinoIcons.delete,
              size: 20,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    ),
  );
}
