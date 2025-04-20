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
        // color: isSelected ? Theme.of(context).cardColor : Colors.grey.shade100,
        color: Theme.of(context).cardColor,
        borderRadius: SizeConst.kBorderRadius,
        border: Border.all(
          width: 1.5,
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
