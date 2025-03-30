import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/quantity_dialog_control.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/weight_dialog_control.dart';

///cart item list widget
Container cartItemListWidget({
  required Size screenSize,
  required CartState state,
  required BuildContext context,
}) {
  return Container(
    height: screenSize.height * 0.48,
    child: SingleChildScrollView(
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          state.menu == 0
              ? Container()
              : Container(
                  padding: EdgeInsets.only(left: SizeConst.kHorizontalPadding),
                  child: Text(
                    "စားပွဲနံပါတ် : ${state.tableNumber}",
                  ),
                ),
          state.menu == null
              ? Container()
              : cartMenuWidget(
                  ontapDisable: false,
                  menu: state.menu!,
                  context: context,
                  spicyLevel: state.spicyLevel,
                  athoneLevel: state.athoneLevel,
                  onDelete: () {
                    context.read<CartCubit>().removeMenu();
                  },
                  onEdit: () {},
                  screenSize: screenSize,
                ),
          ...state.items
              .map(
                (e) => cartItemWidget(
                  ontapDisable: false,
                  cartItem: e,
                  screenSize: screenSize,
                  context: context,
                  onEdit: () {
                    ///show cart item quantity control
                    if (e.is_gram) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CartItemWeightControlDialog(
                            screenSizeWidth: screenSize.width,
                            weightGram: e.qty,
                            cartItem: e,
                            isEditState: false,
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CartItemQtyDialogControl(
                            screenSizeWidth: screenSize.width,
                            quantity: e.qty,
                            cartItem: e,
                            isEditState: false,
                          );
                        },
                      );
                    }
                  },
                  onDelete: () {
                    context.read<CartCubit>().removeFromCart(item: e);
                  },
                ),
              )
              .toList(),
        ],
      ),
    ),
  );
}
