import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

class CartHeaderWidget extends StatelessWidget {
  final VoidCallback onClearOrder;

  const CartHeaderWidget({
    super.key,
    required this.onClearOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      margin: EdgeInsets.only(top: SizeConst.kVerticalSpacing),
      child: Row(
        children: [
          const Text(
            "Order",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onClearOrder,
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0)
            ),
            child: Text("Clear Cart"),
          )
        ],
      ),
    );
  }
}
