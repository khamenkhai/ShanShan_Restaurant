import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/response_models/product_model.dart';

class MenuBoxWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final CartItem? defaultItem;
  final bool isEditState;

  const MenuBoxWidget(
      {super.key,
      required this.constraints,
      this.defaultItem,
      required this.isEditState});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        borderRadius: SizeConst.kBorderRadius,
        color: Theme.of(context).cardColor,
        child: Container(
          width: ((constraints.maxWidth - SizeConst.kGlobalPadding) / 2),
          decoration: BoxDecoration(
            borderRadius: SizeConst.kBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConst.kGlobalPadding,
                  vertical: SizeConst.kGlobalPadding / 2,
                ),
                child: Row(
                  children: [
                    
                    Text("🍽️", style: context.subTitle()),
                    const SizedBox(width: 12),
                    Text("မီနူး", style: context.subTitle()),
                  ],
                ),
              ),
             
              BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state is MenuLoadingState) {
                    return const LoadingWidget();
                  } else if (state is MenuLoadedState) {
                    List<MenuModel> menuList = state.menuList;

                    return Padding(
                      padding: const EdgeInsets.only(right: 0, bottom: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: menuList
                              .map(
                                (e) => MenuRowWidget(
                                  menu: e,
                                  defaultItem: defaultItem,
                                  isEditState: isEditState,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  } else {
                    return const Text("");
                  }
                },
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuRowWidget extends StatelessWidget {
  final MenuModel menu;
  final CartItem? defaultItem;
  final bool isEditState;

  const MenuRowWidget({
    super.key,
    required this.menu,
    required this.defaultItem,
    required this.isEditState,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return InkWell(
          highlightColor: ColorConstants.primaryColor.withOpacity(0.3),
          onTap: () => context.read<CartCubit>().addData(menu: menu),
          // onTap: () => _handleMenuTap(context, state),
          child: Container(
            padding: EdgeInsets.only(left: 8),
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CupertinoCheckbox(
                  activeColor: context.primaryColor,
                  value: context.watch<CartCubit>().state.menu?.id == menu.id,
                  onChanged: (value) {
                    context.read<CartCubit>().addData(menu: menu);
                  },
                ),
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
}

class DefaultProductChecker {
  static CartItem? checkDefaultProduct(
      {required List<ProductModel> products,
      required BuildContext context,
      required bool isEditState}) {
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

      if (isEditState) {
        context.read<EditSaleCartCubit>().addToCartByQuantity(
              item: defaultItem,
              quantity: 1,
            );
      } else {
        context.read<CartCubit>().addToCartByQuantity(
              item: defaultItem,
              quantity: 1,
            );
      }

      return defaultItem;
    } catch (e) {
      customPrint("Error checking default product: $e");
      return null;
    }
  }
}
