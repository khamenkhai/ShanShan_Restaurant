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

///menu row widget
Widget menuRowWidget({
  required MenuModel menu,
  required BuildContext context,
  required CartItem? defaultItem,
}) {
  return BlocBuilder<ProductsCubit, ProductsState>(
    builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(bottom: 100),
        child: InkWell(
          // ignore: deprecated_member_use
          highlightColor: ColorConstants.primaryColor.withOpacity(0.3),
          onTap: () async {
            if (menu.isFish == true) {
              context.read<CartCubit>().addMenu(menu: menu);

              context.read<CartCubit>().addSpicy(
                    athoneLevel: null,
                    spicyLevel: null,
                  );
            } else {
              await showDialog(
                context: context,
                builder: (context) {
                  return TasteChooseDialog();
                },
              ).then(
                (value) {
                  if (value != null) {
                    if (!context.mounted) return;
                    context.read<CartCubit>().addMenu(menu: menu);
                    context.read<CartCubit>().addSpicy(
                          athoneLevel: value["athoneLevel"],
                          spicyLevel: value["spicyLevel"],
                        );

                    if (state is ProductsLoadedState) {
                      checkDefaultProduct(
                          products: state.products, context: context);
                    }
                  }
                },
              );
            }
          },
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${menu.name}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

///to check the default product (eg. hinyi/anit)
CartItem? checkDefaultProduct({
  required List<ProductModel> products,
  required BuildContext context,
}) {
  try {
    ProductModel? defaultProduct =
        products.where((element) => element.isDefault == true).first;

    CartItem? defaultItem;

    // ignore: unnecessary_null_comparison
    if (defaultProduct != null) {
      defaultItem = CartItem(
        id: defaultProduct.id!,
        name: defaultProduct.name.toString(),
        price: defaultProduct.price ?? 0,
        qty: 1,
        totalPrice: defaultProduct.price ?? 0,
        isGram: defaultProduct.isGram ?? false,
      );

      context
          .read<CartCubit>()
          .addToCartByQuantity(item: defaultItem, quantity: 1);
    }

    return defaultItem;
  } catch (e) {
    customPrint("error : ${e}");
    return null;
  }
}
