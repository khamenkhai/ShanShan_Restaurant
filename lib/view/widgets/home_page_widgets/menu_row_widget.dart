import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/models/response_models/product_model.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/taste_level_dialog.dart';

class MenuRowWidget extends StatelessWidget {
  final MenuModel menu;
  final CartItem? defaultItem;

  const MenuRowWidget({
    super.key,
    required this.menu,
    required this.defaultItem,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return InkWell(
          // ignore: deprecated_member_use
          highlightColor: ColorConstants.primaryColor.withOpacity(0.3),
          onTap: () => _handleMenuTap(context, state),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConst.kHorizontalPadding,
            ),
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  menu.name ?? "",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleMenuTap(BuildContext context, ProductsState state) async {
    if (menu.isFish == true) {
      context.read<CartCubit>().addData(
            menu: menu,
            htoneLevel: null,
            spicyLevel: null,
          );
    } else {
      final result = await showDialog(
        context: context,
        builder: (context) => const TasteChooseDialog(),
      );

      if (result != null && context.mounted) {
        context.read<CartCubit>().addData(
              menu: menu,
              htoneLevel: result["athoneLevel"],
              spicyLevel: result["spicyLevel"],
            );

        if (state is ProductsLoadedState) {
          DefaultProductChecker.checkDefaultProduct(
            products: state.products,
            context: context,
          );
        }
      }
    }
  }
}

class DefaultProductChecker {
  static CartItem? checkDefaultProduct({
    required List<ProductModel> products,
    required BuildContext context,
  }) {
    try {
      final defaultProduct = products.firstWhere(
        (element) => element.isDefault == true,
      );

      final defaultItem = CartItem(
        id: defaultProduct.id!,
        name: defaultProduct.name ?? "",
        price: defaultProduct.price ?? 0,
        qty: 1,
        totalPrice: defaultProduct.price ?? 0,
        isGram: defaultProduct.isGram ?? false,
      );

      context.read<CartCubit>().addToCartByQuantity(
            item: defaultItem,
            quantity: 1,
          );

      return defaultItem;
    } catch (e) {
      customPrint("Error checking default product: $e");
      return null;
    }
  }
}
