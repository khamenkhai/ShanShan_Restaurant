import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/home/widget/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/quantity_dialog_control.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/weight_dialog_control.dart';

class CartListWidget extends StatelessWidget {
  final Size screenSize;
  final CartState state;

  const CartListWidget({
    super.key,
    required this.screenSize,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.menu != null)
            CartMenuWidget(
              tapDisabled: false,
              menu: state.menu!,
              spicyLevel: state.spicyLevel,
              athoneLevel: state.athoneLevel,
              onDelete: () => context.read<CartCubit>().addData(
                menu: null,
                spicyLevel: null,
                htoneLevel: null,
              ),
              onEdit: () {},
            ),
          ...state.items.map(
            (e) => CartItemWidget(
              ontapDisable: false,
              cartItem: e,
              onEdit: () => _showEditDialog(context, e),
              onDelete: () =>
                  context.read<CartCubit>().removeFromCart(item: e),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, CartItem e) {
    showDialog(
      context: context,
      builder: (context) {
        return e.isGram
            ? CartItemWeightControlDialog(
                screenSizeWidth: screenSize.width,
                weightGram: e.qty,
                cartItem: e,
                isEditState: false,
              )
            : CartItemQtyDialogControl(
                screenSizeWidth: screenSize.width,
                quantity: e.qty,
                cartItem: e,
                isEditState: false,
              );
      },
    );
  }
}
