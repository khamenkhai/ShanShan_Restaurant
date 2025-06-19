// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final bool ontapDisable;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.ontapDisable,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Theme.of(context).cardColor,
          child: InkWell(
            borderRadius: SizeConst.kBorderRadius,
            onTap: onEdit,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildItemInfo(context),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "${NumberFormat('#,##0').format(cartItem.totalPrice)} MMK",
                        style: context.normalFont(
                            color: context.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (!ontapDisable) _buildDeleteButton(),
                ],
              ),
            ),
          ),
        ),
        // Container(
        //   height: 0.2,
        //   margin: EdgeInsets.only(top: 4),
        //   width: double.infinity,
        //   color: context.hintColor,
        // )
      ],
    );
  }

  Widget _buildItemInfo(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cartItem.name,
            style: context.normalFont(),
          ),
          const SizedBox(height: 4),
          Text(
            cartItem.isGram
                ? "${cartItem.qty}gram x ${cartItem.price}"
                : "${cartItem.qty} x ${cartItem.price} MMK",
            style: context.smallFont(color: context.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: onDelete,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: const Icon(IconlyLight.delete, size: 20),
      ),
    );
  }
}

class CartMenuWidget extends StatelessWidget {
  final MenuModel menu;
  final SpicyLevelModel? spicyLevel;
  final AhtoneLevelModel? athoneLevel;
  final bool tapDisabled;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CartMenuWidget({
    super.key,
    required this.menu,
    this.spicyLevel,
    this.athoneLevel,
    required this.tapDisabled,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: SizeConst.kBorderRadius,
      onTap: onEdit,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConst.kGlobalPadding,
          vertical: SizeConst.kGlobalPadding / 2,
        ),
        decoration: BoxDecoration(
          borderRadius: SizeConst.kBorderRadius,
          color: context.primaryColor.withOpacity(0.04),
          border: Border.all(
            width: 1,
            color: context.primaryColor.withOpacity(0.5),
          ),
        ),
        child: Column(
          children: [
            _buildMenuRow(context),
            Row(
              children: [
                if (spicyLevel != null) _buildSpicyLevel(context),
                Text(
                  " •",
                  style: context.normalFont(color: context.primaryColor),
                ),
                if (athoneLevel != null) _buildAthoneLevel(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            menu.name ?? "",
            style: context.normalFont(
              color: context.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (!tapDisabled) _buildDeleteButton(),
      ],
    );
  }

  Widget _buildSpicyLevel(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 7),
        SizedBox(
          width: 80,
          child: Text(
            "အစပ် Level ",
            style: context.smallFont(
                color: context.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "-  ${spicyLevel!.name}",
          style: context.smallFont(
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAthoneLevel(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 7),
        SizedBox(
          width: 80,
          child: Text(
            "အထုံ Level",
            style: context.smallFont(
              color: context.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          "-  ${athoneLevel!.name}",
          style: context.smallFont(
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: InkWell(
        onTap: onDelete,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: const Icon(IconlyLight.delete, size: 20),
      ),
    );
  }
}
