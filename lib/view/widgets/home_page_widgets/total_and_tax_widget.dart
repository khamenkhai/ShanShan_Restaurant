import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
///widget that shows total and tax
Widget totalAndTaxHomeWidget({required CartCubit cartCubit}) {
  num grandTotal =
      get5percentage(cartCubit.getTotalAmount()) + cartCubit.getTotalAmount();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15, top: 5),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: ColorConstants.greyColor,
          ),
        ),

        SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Subtotal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${NumberFormat('#,##0').format(cartCubit.getTotalAmount())} MMK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),

        ///tax
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Tax(5%)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${formatNumber(get5percentage(cartCubit.getTotalAmount()))}MMK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),

        ///grand total
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Grand Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${NumberFormat('#,##0').format(grandTotal)} MMK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
