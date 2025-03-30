import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/model/response_models/menu_model.dart';
import 'package:shan_shan/model/data_models/spicy_level.dart';

/**
   * widget to show each receive product with quantity,amount,
   */
Widget cartItemWidget({
  required CartItem cartItem,
  required BuildContext context,
  required Size screenSize,
  required Function() onEdit,
  required Function() onDelete,
  required bool ontapDisable,
}) {
  return Material(
    color: Colors.white,
    child: InkWell(
      borderRadius: SizeConst.kBorderRadius,
      splashColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      highlightColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          top: 8,
          left: SizeConst.kHorizontalPadding,
          right: SizeConst.kHorizontalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${cartItem.name}",
                    style: TextStyle(
                      fontSize: 14 - 1,
                    ),
                  ),
                  cartItem.is_gram
                      ? Text(
                          "${cartItem.qty}gram x ${cartItem.price} ",
                          style: TextStyle(
                            fontSize: 14 - 1,
                          ),
                        )
                      : Text(
                          "${cartItem.qty} x ${cartItem.price} MMK",
                          // "${cartItem.price}MMK/${cartItem.qty} MMK",
                          style: TextStyle(
                            fontSize: 14 - 1,
                          ),
                        ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      //"${cartItem.totalPrice} MMK",
                      "${NumberFormat('#,##0').format(cartItem.totalPrice)} MMK",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ontapDisable ? Container() : SizedBox(width: 10),
            ontapDisable
                ? Container()
                : InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onDelete,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Icon(
                        CupertinoIcons.delete_solid,
                        size: 20,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

Widget cartMenuWidget({
  required MenuModel menu,
  required SpicyLevelModel? spicyLevel,
  required AhtoneLevelModel? athoneLevel,
  required BuildContext context,
  required Size screenSize,
  required Function() onEdit,
  required Function() onDelete,
  required bool ontapDisable,
}) {
  return Material(
    color: Colors.white,
    child: InkWell(
      borderRadius: SizeConst.kBorderRadius,
      splashColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      highlightColor: ontapDisable ? Colors.transparent : Colors.grey.shade100,
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
          top: 0,
          left: SizeConst.kHorizontalPadding,
          right: SizeConst.kHorizontalPadding,
        ),
        child: Column(
          children: [
            ///menu widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${menu.name}",
                        style: TextStyle(
                          fontSize: 14 - 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                SizedBox(width: 20),
                ontapDisable
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: InkWell(
                          onTap: onDelete,
                          // onTap: () async {

                          // },
                          child: Icon(
                            CupertinoIcons.delete_solid,
                            size: 20,
                          ),
                        ),
                      ),
              ],
            ),

            ///spicy level widget
            SizedBox(height: 4),
            spicyLevel == null
                ? Container()
                : Row(
                    children: [
                      SizedBox(width: 7),
                      Container(
                        width: 80,
                        child: Text(
                          "အစပ် Level ",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14 - 1,
                          ),
                        ),
                      ),
                      Text(
                        "-  ${spicyLevel.name}",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14 - 1,
                        ),
                      ),
                    ],
                  ),

            ///athone level widget
            SizedBox(height: 4),
            athoneLevel == null
                ? Container()
                : Row(
                    children: [
                      SizedBox(width: 7),
                      Container(
                        width: 80,
                        child: Text(
                          "အထုံ Level",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14 - 1,
                          ),
                        ),
                      ),
                      Text(
                        "-  ${athoneLevel.name}",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14 - 1,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    ),
  );
}
