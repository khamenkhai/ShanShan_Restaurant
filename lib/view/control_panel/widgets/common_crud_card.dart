// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

class CrudCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CrudCard({
    super.key,
    required this.title,
    this.description = "",
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConst.kGlobalPadding - 3,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit, size: 20, color: Theme.of(context).primaryColor),
            ),
            IconButton(
              onPressed: onDelete,
              icon:
                  const Icon(CupertinoIcons.delete, size: 20, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
