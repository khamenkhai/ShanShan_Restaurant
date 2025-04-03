import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/models/response_models/product_model.dart';
import 'package:shan_shan/view/widgets/product_detail_control.dart';
import 'package:shan_shan/view/widgets/table_number_dialog.dart';

///product row widget
Widget productRowWidget({
  required ProductModel product,
  required BuildContext context,
  required TextEditingController tableController,
  required bool isEditState,
}) {
  CartCubit cartCubit = BlocProvider.of<CartCubit>(context);
  return InkWell(
    // ignore: deprecated_member_use
    highlightColor: ColorConstants.primaryColor.withOpacity(0.3),
    onTap: () {
      if (isEditState) {
        showDialog(
          context: context,
          builder: (context) {
            return ProductWeightOrDetailControl(
              produt: product,
              isEditState: true,
            );
          },
        );
      } else {
        if (cartCubit.state.tableNumber == 0) {
          showDialog(
            context: context,
            builder: (context) {
              return TableNumberDialog(
                tableController: tableController,
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return ProductWeightOrDetailControl(
                produt: product,
                isEditState: false,
              );
            },
          );
        }
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${product.name}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            "${product.price} MMK",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
