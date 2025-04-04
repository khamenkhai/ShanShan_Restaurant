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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConst.kHorizontalPadding - 3,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: SizeConst.kBorderRadius),
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
                    color: Colors.black,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ]
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
          ),
          IconButton(
            onPressed: onDelete,
            icon:
                const Icon(CupertinoIcons.delete, size: 20, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
