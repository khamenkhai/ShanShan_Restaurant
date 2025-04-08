import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';

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
    final commercialTax = grandTotal - subTotal;
    final textStyleSmall = TextStyle(
      fontSize: 13.5, // 16 - 2.5
      color: Colors.black87,
    );
    const textStyleBold = TextStyle(fontWeight: FontWeight.bold);
    const textStyleNormal = TextStyle(fontWeight: FontWeight.normal);

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          const Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 9),
          const SizedBox(height: 15),
          
          // Table Number Row
          _buildInfoRow("Table Number", "$tableNumber", style: textStyleSmall),
          const SizedBox(height: 10),
          
          // Slip Number Row
          _buildInfoRow("Slit Number", orderNumber, style: textStyleSmall),
          const SizedBox(height: 10),
          
          // Date Row
          _buildInfoRow("Date", date, style: textStyleSmall),
          const SizedBox(height: 25),
          
          // Menu and Remark Section
          Text(menu, style: textStyleBold),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dineInOrParcel == 1 ? "ထိုင်စား" : "ပါဆယ်"),
              Text("Remark : $remark", textAlign: TextAlign.right),
            ],
          ),
          const SizedBox(height: 5),
          
          // Ahtone Level
          if (ahtoneLevel != null && ahtoneLevel!.name!.isNotEmpty)
            Text(
              "အထုံ Level - ${ahtoneLevel!.name}",
              style: TextStyle(
                fontSize: 13, // 14 - 1
                color: Colors.black,
              ),
            ),
          
          // Spicy Level
          if (spicyLevel != null && spicyLevel!.name!.isNotEmpty)
            Text(
              "အစပ် Level - ${spicyLevel!.name}",
              style: TextStyle(
                fontSize: 13, // 14 - 1
                color: Colors.black,
              ),
            ),
          const SizedBox(height: 10),
          
          // Products Title Row
          _buildProductsTitleRow(),
          const SizedBox(height: 15),
          
          // Product Items
          ...cartItems.map((e) => _buildVoucherItem(e)).toList(),
          
          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(height: 0, thickness: 1),
          ),
          
          // Totals Section
          Column(
            children: [
              _buildAmountRow("Total Amount", subTotal, 
                  style: textStyleBold, valueStyle: textStyleNormal),
              const SizedBox(height: 10),
              _buildAmountRow("Tax", commercialTax, 
                  style: textStyleBold, valueStyle: textStyleNormal),
              const SizedBox(height: 10),
              _buildAmountRow("GrandTotal", grandTotal, 
                  style: textStyleBold, valueStyle: textStyleNormal),
              
              // Divider
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Divider(height: 0, thickness: 1),
              ),
              
              // Payment Details
              _buildAmountRow("Discount", discount, 
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  valueStyle: const TextStyle(fontSize: 14)),
              const SizedBox(height: 10),
              _buildAmountRow("Cash Amount", cashAmount, 
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  valueStyle: const TextStyle(fontSize: 14)),
              const SizedBox(height: 10),
              _buildAmountRow("Kpay Amount", bankAmount, 
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  valueStyle: const TextStyle(fontSize: 14)),
              const SizedBox(height: 15),
              
              // Seafood Counts
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prawnAmount > 0) Text("ပုဇွန် : $prawnAmount , "),
                  if (octopusCount > 0) Text("ရေဘဝဲ : $octopusCount"),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? style}) {
    return Row(
      children: [
        Expanded(flex: 4, child: Text(label, style: style)),
        const Expanded(flex: 1, child: Text(":", textAlign: TextAlign.center)),
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(value, style: style),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(
    String label, 
    num amount, {
    TextStyle? style,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 4, child: Text(label, style: style)),
        const Expanded(flex: 1, child: Text(":", textAlign: TextAlign.center)),
        Expanded(
          flex: 4,
          child: Text(
            "${NumberFormat('#,##0').format(amount)} MMK",
            textAlign: TextAlign.right,
            style: valueStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsTitleRow() {
    const style = TextStyle(fontWeight: FontWeight.w500);
    return const Row(
      children: [
        Expanded(flex: 1, child: Text("Name", style: style)),
        Expanded(flex: 1, child: Text("Qty", textAlign: TextAlign.right, style: style)),
        Expanded(flex: 1, child: Text("Price", textAlign: TextAlign.right, style: style)),
        Expanded(flex: 1, child: Text("Amount", textAlign: TextAlign.end, style: style)),
      ],
    );
  }

  Widget _buildVoucherItem(CartItem e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(e.name)),
          Expanded(
            flex: 1,
            child: Text(
              e.isGram ? "${e.qty} gram" : "${e.qty}",
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
}