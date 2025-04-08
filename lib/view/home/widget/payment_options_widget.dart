import 'package:flutter/material.dart';
import 'package:shan_shan/view/widgets/payment_button.dart';

class PaymentOptionsWidget extends StatelessWidget {
  final bool paidCash;
  final bool paidOnline;
  final ValueChanged<bool> onCashChanged;
  final ValueChanged<bool> onKpayChanged;
  
  const PaymentOptionsWidget({
    super.key,
    required this.paidCash,
    required this.paidOnline,
    required this.onCashChanged,
    required this.onKpayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 11),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onCashChanged(!paidCash),
              child: PaymentButton(
                isSelected: paidCash,
                title: "Cash",
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () => onKpayChanged(!paidOnline),
              child: PaymentButton(
                isSelected: paidOnline,
                title: "Online Pay",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
