import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/utils.dart';

/// Widget that displays subtotal, tax, and grand total.
// ignore: must_be_immutable
class TotalAndTaxHomeWidget extends StatelessWidget {
  TotalAndTaxHomeWidget({super.key, required this.isEditState});
  final bool isEditState;

  int subTotal = 0;
  int tax = 0;
  int grandTotal = 0;
  @override
  Widget build(BuildContext context) {
    if (!isEditState) {
      final CartCubit cartCubit = context.read<CartCubit>();
      subTotal = cartCubit.getTotalAmount();
      tax = get5percentage(subTotal.toInt());
      grandTotal = subTotal + tax;
    }else{
      final OrderEditCubit orderCart = context.read<OrderEditCubit>();
      subTotal = orderCart.getTotalAmount();
      tax = get5percentage(subTotal.toInt());
      grandTotal = subTotal + tax;
    }

    return Column(
      children: [
        _buildDivider(),
        _buildTotalRow(tr(LocaleKeys.subtotal), subTotal),
        _buildTotalRow("${tr(LocaleKeys.tax)} (5%)", tax),
        _buildTotalRow(tr(LocaleKeys.grandTotal), grandTotal),
      ],
    );
  }

  /// Builds a horizontal divider.
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: AppColors.greyColor,
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
