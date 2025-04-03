import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          const Icon(IconlyBold.bookmark),
          const SizedBox(width: 10),
          const Text(
            "Order",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConstants.primaryColor,
              fontSize: 17,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onClearOrder,
            child: Container(
              padding: const EdgeInsets.symmetric( vertical: 3),
              decoration: BoxDecoration(
                borderRadius: SizeConst.kBorderRadius,
                color: Colors.white,
              ),
              child: Icon(IconlyBold.close_square)
            ),
          ),
        ],
      ),
    );
  }
}