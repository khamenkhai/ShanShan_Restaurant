// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/model/data_models/spicy_level.dart';

class VoucherWidget extends StatelessWidget {
  const VoucherWidget({
    super.key,
    required this.cashAmount,
    required this.bankAmount,
    required this.change,
    required this.subTotal,
    required this.grandTotal,
    required this.date,
    required this.orderNumber,
    required this.cartItems,
    required this.octopusCount,
    required this.prawnAmount,
    required this.dineInOrParcel,
    required this.discount,
    required this.remark,
    required this.menu,
    this.ahtoneLevel,
    this.spicyLevel,
    required this.tableNumber,
    required this.showEditButton,
    required this.paymentType,
  });

  final int cashAmount;
  final int bankAmount;
  final int change;
  final int subTotal;
  final int grandTotal;
  final String date;
  final String orderNumber;
  final List<CartItem> cartItems;
  final int octopusCount;
  final int prawnAmount;
  final int dineInOrParcel;
  final int discount;
  final String remark;
  final String menu;
  final AhtoneLevelModel? ahtoneLevel;
  final SpicyLevelModel? spicyLevel;
  final int tableNumber;
  final bool showEditButton;
  final String paymentType;

  @override
  Widget build(BuildContext context) {
    num commercialTax = grandTotal - subTotal;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 9),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  "Table Number",
                  style: TextStyle(fontSize: 16 - 2.5),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ":",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16 - 2.5),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "$tableNumber",
                    style: TextStyle(fontSize: 16 - 2.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  "Slit Number",
                  style: TextStyle(fontSize: 16 - 2.5),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ":",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16 - 2.5),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "$orderNumber",
                    style: TextStyle(fontSize: 16 - 2.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 16 - 2.5,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  ":",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16 - 2.5,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "$date",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16 - 2.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Text(
            "$menu",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dineInOrParcel == 1 ? "ထိုင်စား" : "ပါဆယ်"),
              Text(
                "Remark : $remark ",
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 5),
          ahtoneLevel == null
              ? Container()
              : Visibility(
                  visible: ahtoneLevel!.name != "",
                  child: Text(
                    "အထုံ Level - ${ahtoneLevel!.name.toString()}",
                    style: TextStyle(
                        fontSize: 14 - 1,
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.95)),
                  ),
                ),
          spicyLevel == null
              ? Container()
              : Visibility(
                  visible: spicyLevel!.name != "",
                  child: Text(
                    "အစပ် Level - ${spicyLevel!.name.toString()}",
                    style: TextStyle(
                      fontSize: 14 - 1,
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.95),
                    ),
                  ),
                ),
          SizedBox(height: 10),
          _productsTitleRow(),
          SizedBox(height: 15),
          Column(
            children: cartItems.map(
              (e) {
                return _voucherItemWidget(e);
              },
            ).toList(),
          ),
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Divider(
              height: 0,
              thickness: 1,
            ),
          ),
          Column(
            children: [
              ///subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Total Amount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        ":",
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "${NumberFormat('#,##0').format(subTotal)} MMK",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              ///commercial tax
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Tax",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        ":",
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "${NumberFormat('#,##0').format(commercialTax)} MMK",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              ///grand total
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "GrandTotal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        ":",
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "${NumberFormat('#,##0').format(grandTotal)} MMK",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              ///cash
              Container(
                margin: EdgeInsets.only(
                  top: SizeConst.kHorizontalPadding + 10,
                  bottom: SizeConst.kHorizontalPadding + 10,
                ),
                child: Divider(
                  height: 0,
                  thickness: 1,
                ),
              ),

              _discountRow(),
              SizedBox(height: 10),
              _cashRow(cashAmount: cashAmount),
              SizedBox(height: 10),
              _bankRow(kpay: bankAmount),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prawnAmount > 0
                      ? Text("ပုဇွန် : $prawnAmount , ")
                      : Container(),
                  octopusCount > 0
                      ? Text("ရေဘဝဲ : $octopusCount")
                      : Container(),
                ],
              ),

              SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Row _discountRow() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "Discount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              ":",
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 4,
          child: Text(
            "${NumberFormat('#,##0').format(discount)} MMK",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Row _cashRow({required int cashAmount}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "Cash Amount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              ":",
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 4,
          child: Text(
            "${formatNumber(cashAmount)} MMK",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Row _bankRow({required int kpay}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            "Kpay Amount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              ":",
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 4,
          child: Text(
            "${formatNumber(kpay)} MMK",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Row _productsTitleRow() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "Name",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Qty",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Price",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Amount",
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  ///voucher cart product item widget
  Container _voucherItemWidget(CartItem e) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("${e.name}"),
          ),
          Expanded(
            flex: 1,
            child: Text(
              e.is_gram ? "${e.qty} gram" : "${e.qty}",
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${e.price}",
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${e.totalPrice}",
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  ///voucher cart product item widget
  Container _voucherItemWidgetOld(CartItem e) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${e.name}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  e.is_gram
                      ? "${e.qty} gram x  ${formatNumber(e.price)} MMK "
                      : "${e.qty} qty x ${formatNumber(e.price)} MMK",
                )
              ],
            ),
          ),
          Text("${NumberFormat('#,##0').format(e.totalPrice)} MMK")
        ],
      ),
    );
  }
}
