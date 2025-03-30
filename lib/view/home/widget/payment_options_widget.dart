import 'package:flutter/material.dart';
import 'package:shan_shan/view/widgets/payment_button.dart';

class PaymentOptionsWidget extends StatelessWidget {
  final bool cashPayment;
  final bool kpayPayment;
  final ValueChanged<bool> onCashChanged;
  final ValueChanged<bool> onKpayChanged;
  
  const PaymentOptionsWidget({
    super.key,
    required this.cashPayment,
    required this.kpayPayment,
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
              onTap: () => onCashChanged(!cashPayment),
              child: PaymentButton(
                isSelected: cashPayment,
                title: "Cash",
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () => onKpayChanged(!kpayPayment),
              child: PaymentButton(
                isSelected: kpayPayment,
                title: "KBZ Pay",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
