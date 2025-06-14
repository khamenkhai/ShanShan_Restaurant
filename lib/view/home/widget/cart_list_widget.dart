import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
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
    return BaseCartListWidget(
      screenSize: screenSize,
      menu: state.menu,
      items: state.items,
      spicyLevel: state.spicyLevel,
      athoneLevel: state.athoneLevel,
    );
  }
}

class EditCartListWidget extends StatelessWidget {
  final Size screenSize;
  final EditSaleCartState state;

  const EditCartListWidget({
    super.key,
    required this.screenSize,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCartListWidget(
      screenSize: screenSize,
      menu: state.menu,
      items: state.items,
      spicyLevel: state.spicyLevel,
      athoneLevel: state.athoneLevel,
    );
  }
}

class BaseCartListWidget extends StatelessWidget {
  final Size screenSize;
  final dynamic menu;
  final List<CartItem> items;
  final SpicyLevelModel? spicyLevel;
  final AhtoneLevelModel? athoneLevel;

  const BaseCartListWidget({
    super.key,
    required this.screenSize,
    required this.menu,
    required this.items,
    this.spicyLevel,
    this.athoneLevel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (menu != null)
            CartMenuWidget(
              tapDisabled: false,
              menu: menu,
              spicyLevel: spicyLevel,
              athoneLevel: athoneLevel,
              onDelete: () => context.read<CartCubit>().addData(
                    menu: null,
                    spicyLevel: null,
                    htoneLevel: null,
                  ),
              onEdit: () {},
            ),
          ...items.map(
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

  static void _showEditDialog(BuildContext context, CartItem e) {
    showDialog(
      context: context,
      builder: (context) {
        return e.isGram
            ? CartItemWeightControlDialog(
                screenSizeWidth: MediaQuery.of(context).size.width,
                weightGram: e.qty,
                cartItem: e,
                isEditState: false,
              )
            : CartItemQtyDialogControl(
                screenSizeWidth: MediaQuery.of(context).size.width,
                quantity: e.qty,
                cartItem: e,
                isEditState: false,
              );
      },
    );
  }
}
