import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/core/const/size_const.dart';
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
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: SizeConst.kBorderRadius,
        splashColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
        highlightColor:
            ontapDisable ? Colors.transparent : Colors.grey.shade100,
        onTap: onEdit,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: SizeConst.kHorizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildItemInfo(),
              _buildItemPrice(),
              if (!ontapDisable) _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemInfo() {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cartItem.name,
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            cartItem.isGram
                ? "${cartItem.qty}gram x ${cartItem.price}"
                : "${cartItem.qty} x ${cartItem.price} MMK",
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildItemPrice() {
    return Expanded(
      flex: 2,
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          "${NumberFormat('#,##0').format(cartItem.totalPrice)} MMK",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: InkWell(
        onTap: onDelete,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: const Icon(IconlyBold.delete, size: 20),
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
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: SizeConst.kBorderRadius,
        splashColor: tapDisabled ? Colors.transparent : Colors.grey.shade100,
        highlightColor: tapDisabled ? Colors.transparent : Colors.grey.shade100,
        onTap: onEdit,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConst.kHorizontalPadding,
          ),
          child: Column(
            children: [
              _buildMenuRow(),
              if (spicyLevel != null) _buildSpicyLevel(),
              if (athoneLevel != null) _buildAthoneLevel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              menu.name ?? "",
              style: const TextStyle(fontSize: 13),
            ),
          ),
          if (!tapDisabled) _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildSpicyLevel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const SizedBox(width: 7),
          SizedBox(
            width: 80,
            child: Text(
              "အစပ် Level ",
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            "-  ${spicyLevel!.name}",
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthoneLevel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const SizedBox(width: 7),
          SizedBox(
            width: 80,
            child: Text(
              "အထုံ Level",
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            "-  ${athoneLevel!.name}",
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: InkWell(
        onTap: onDelete,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: const Icon(IconlyBold.delete, size: 20),
      ),
    );
  }
}
