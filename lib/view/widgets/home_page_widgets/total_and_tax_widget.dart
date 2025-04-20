import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';

/// Widget that displays subtotal, tax, and grand total.
class TotalAndTaxHomeWidget extends StatelessWidget {
  const TotalAndTaxHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CartCubit cartCubit = context.read<CartCubit>();
    num subtotal = cartCubit.getTotalAmount();
    num tax = get5percentage(subtotal.toInt());
    num grandTotal = subtotal + tax;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeConst.kHorizontalPadding,
      ),
      child: Column(
        children: [
          _buildDivider(),
          _buildTotalRow("Subtotal", subtotal),
          _buildTotalRow("Tax (5%)", tax),
          _buildTotalRow("Grand Total", grandTotal),
        ],
      ),
    );
  }

  /// Builds a horizontal divider.
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: ColorConstants.greyColor,
      ),
    );
  }

  /// Builds a row displaying a label and a formatted amount.
  Widget _buildTotalRow(String label, num amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${NumberFormat('#,##0').format(amount)} MMK",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
