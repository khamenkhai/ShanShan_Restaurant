import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';

class VoucherWidget extends StatelessWidget {
  const VoucherWidget({
    super.key,
    required this.cashAmount,
    required this.bankAmount,
    required this.refund,
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
  final int refund;
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildBasicInfoSection(),
          const SizedBox(height: 15),
          _buildMenuSection(),
          _buildLevelSection(),
          const SizedBox(height: 10),
          _buildProductsTitleRow(),
          const SizedBox(height: 15),
          ...cartItems.map((e) => _buildVoucherItem(e)),
          const Divider(height: 30),
          _buildTotalSection(commercialTax),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          "📋 Order Receipt",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            dineInOrParcel == 1 ? "Dine In" : "Parcel",
            style: context.smallFont(
                color: context.cardColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: context.cardColor,
            border: Border.all(width: 1, color: context.primaryColor),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "Table : $tableNumber",
            style: context.smallFont(
              color: context.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    final style = TextStyle(
      fontSize: 13.5,
      // color: Colors.black87,
    );
    return Column(
      children: [
        SizedBox(height: 10),
        _buildInfoRow("Slip Number", orderNumber, style: style),
        _buildInfoRow("Date", date, style: style),
      ]
          .map((e) =>
              Padding(padding: const EdgeInsets.only(bottom: 10), child: e))
          .toList(),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(menu, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Remark: $remark", textAlign: TextAlign.right),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ahtoneLevel != null && ahtoneLevel!.name!.isNotEmpty)
          Text("အထုံ Level - ${ahtoneLevel!.name}",
              style: const TextStyle(fontSize: 13)),
        if (spicyLevel != null && spicyLevel!.name!.isNotEmpty)
          Text("အစပ် Level - ${spicyLevel!.name}",
              style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildProductsTitleRow() {
    const style = TextStyle(fontWeight: FontWeight.w500);
    return const Row(
      children: [
        Expanded(flex: 1, child: Text("Name", style: style)),
        Expanded(
            flex: 1,
            child: Text("Qty", textAlign: TextAlign.right, style: style)),
        Expanded(
            flex: 1,
            child: Text("Price", textAlign: TextAlign.right, style: style)),
        Expanded(
            flex: 1,
            child: Text("Amount", textAlign: TextAlign.end, style: style)),
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
            child: Text(e.isGram ? "${e.qty} gram" : "${e.qty}",
                textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 1,
            child: Text("${e.price}", textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 1,
            child: Text("${e.totalPrice}", textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(int commercialTax) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAmountRow("Subtotal", subTotal),
        _buildAmountRow("Tax", commercialTax),
        _buildAmountRow("Discount", discount),
        _buildAmountRow("Grand Total", grandTotal, isBold: true),
        const Divider(height: 30),
        _buildAmountRow("Cash Paid", cashAmount),
        _buildAmountRow("Online Paid", bankAmount),
        if (refund > 0)
          _buildAmountRow(
            "Refund Amount",
            refund,
            isBold: true,
            color: Colors.redAccent,
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prawnAmount > 0) Text("ပုဇွန် : $prawnAmount , "),
            if (octopusCount > 0) Text("ရေဘဝဲ : $octopusCount"),
          ],
        ),
      ],
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
                child: Text(value, style: style))),
      ],
    );
  }

  Widget _buildAmountRow(
    String label,
    num amount, {
    bool isBold = false,
    Color? color,
  }) {
    final style = TextStyle(
      fontSize: 14,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      // color: color ?? Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(label, style: style)),
          const Expanded(
              flex: 1, child: Text(":", textAlign: TextAlign.center)),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("${NumberFormat('#,##0').format(amount)} MMK",
                  style: style),
            ),
          ),
        ],
      ),
    );
  }
}
