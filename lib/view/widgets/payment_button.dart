import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.isSelected,
    required this.title,
  });
  final bool isSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey.shade100,
        borderRadius: SizeConst.kBorderRadius,
        border: Border.all(
          width: 1.5,
          color: isSelected ? ColorConstants.primaryColor : Colors.transparent,
        ),
      ),
      child: Center(
        child: Text(
          "$title",
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? ColorConstants.primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
