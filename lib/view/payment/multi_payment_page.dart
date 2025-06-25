import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/sale_success/sale_success_page.dart';
import 'package:shan_shan/view/widgets/date_action_widget.dart';
import 'package:shan_shan/view/widgets/number_buttons.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MultiPaymentPage extends StatefulWidget {
  const MultiPaymentPage({super.key});

  @override
  State<MultiPaymentPage> createState() => _MultiPaymentPageState();
}

class _MultiPaymentPageState extends State<MultiPaymentPage> {
  final TextEditingController _cashController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();

  int _cashAmount = 0;
  int _paidOnline = 0;
  int _refundAmount = 0;
  int _subTotal = 0;
  int _taxAmount = 0;
  int _grandTotal = 0;
  int _paymentIndex = 0;
  bool _customerTakeVoucher = true;

  @override
  void dispose() {
    _cashController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _calculateAmounts() {
    final cartCubit = context.read<CartCubit>();
    _subTotal = cartCubit.getTotalAmount();
    _taxAmount = _customerTakeVoucher ? get5percentage(_subTotal) : 0;
    _grandTotal = _subTotal + _taxAmount;
  }

  void _calculateRefund() {
    final grandTotal =
        _customerTakeVoucher ? _subTotal + _taxAmount : _subTotal;
    customPrint("grand total : $_grandTotal");
    customPrint("paid total : ${(_paidOnline + _cashAmount)}");
    customPrint("r : ${(_paidOnline + _cashAmount) - grandTotal}");
    if ((_paidOnline + _cashAmount) > grandTotal) {
      _refundAmount = (_paidOnline + _cashAmount) - grandTotal;
      customPrint("hello world $_refundAmount");
    } else {
      _refundAmount = 0;
    }
    setState(() {});
  }

  bool _isCheckoutEnabled() {
    return (_cashAmount + _paidOnline) >= _grandTotal;
  }

  void _handleCashPayment() {
    _cashAmount =
        _cashController.text.isNotEmpty ? int.parse(_cashController.text) : 0;
    _cashController.text = "0";
    _calculateRefund();
  }

  void _handleKpayPayment() {
    _paidOnline =
        _cashController.text.isNotEmpty ? int.parse(_cashController.text) : 0;
    _cashController.text = "0";
    _calculateRefund();
  }

  Future<void> _processCheckout(
      List<CartItem> cartItems, CartCubit cartCubit) async {
    final grandTotal =
        _customerTakeVoucher ? _subTotal + _taxAmount : _subTotal;
    final discountAmount = _customerTakeVoucher ? 0 : _taxAmount;
    final taxAmount = _customerTakeVoucher ? _taxAmount : 0;

    final dateTime = DateTime.now();
    final saleModel = SaleModel(
      octopusCount: cartCubit.state.octopusCount,
      prawnCount: cartCubit.state.prawnCount,
      remark: cartCubit.state.remark,
      ahtoneLevelId: cartCubit.state.athoneLevel?.id ?? 000,
      spicyLevelId: cartCubit.state.spicyLevel?.id ?? 000,
      dineInOrParcel: cartCubit.state.dineInOrParcel,
      grandTotal: grandTotal,
      menuId: cartCubit.state.menu?.id ?? 0,
      orderNo: "SS-${generateRandomId(6)}",
      paidCash: _cashAmount,
      products: cartItems
          .map((e) => Product(
                productId: e.id,
                qty: e.qty,
                price: e.price,
                totalPrice: e.totalPrice,
              ))
          .toList(),
      tableNumber: cartCubit.state.tableNumber,
      refund: _refundAmount,
      subTotal: _subTotal,
      tax: taxAmount,
      discount: discountAmount,
      paidOnline: _paidOnline,
    );

    final success = await context.read<SaleProcessCubit>().makeSale(
          saleRequest: saleModel,
        );

    if (success && mounted) {
      redirectTo(
        context: context,
        form: SaleSuccessPage(
          customerTakevoucher: _customerTakeVoucher,
          ahtoneLevel: cartCubit.state.athoneLevel,
          menuTitle: cartCubit.state.menu?.name ?? "",
          spicyLevel: cartCubit.state.spicyLevel,
          taxAmount: taxAmount,
          saleData: saleModel,
          cartItems: cartItems,
          paymentType: "Cash / Online",
          dateTime: DateFormat('dd, MMMM yyyy hh:mm a').format(dateTime),
          isEditSale: false,
        ),
        replacement: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cartController = BlocProvider.of<CartCubit>(context);

    _calculateAmounts();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 160,
        toolbarHeight: 56,
        leading: AppBarLeading(onTap: () => Navigator.pop(context)),
        actions: const [
          DateActionWidget(),
          SizedBox(width: 25),
        ],
        title: const Text("Cash & Online Pay"),
      ),
      body: InternetCheckWidget(
        child: Container(
          margin: EdgeInsets.fromLTRB(
            SizeConst.kGlobalMargin,
            SizeConst.kGlobalMargin / 2,
            SizeConst.kGlobalMargin,
            SizeConst.kGlobalMargin,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildOrderSummary(
                  items: cartController.state.items,
                  menuName: cartController.state.menu?.name ?? "",
                  tableNumber: cartController.state.tableNumber.toString(),
                  spicyLevel: cartController.state.spicyLevel?.name ?? "",
                  htoneLevel: cartController.state.athoneLevel?.name ?? "",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildPaymentTabs(screenSize)),
            ],
          ),
        ),
        onRefresh: () {},
      ),
    );
  }

  Widget _buildPaymentTabs(Size screenSize) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(SizeConst.kGlobalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVoucherSection(),
                Row(
                  children: [
                    const Text(
                      "Payment methods :",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ToggleSwitch(
                      minWidth: 90.0,
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: _paymentIndex,
                      totalSwitches: 2,
                      labels: ['Cash', 'Online Pay'],
                      radiusStyle: true,
                      onToggle: (index) {
                        setState(() {
                          _paymentIndex = index!;
                        });
                      },
                    ),
                  ],
                ),
                _paymentIndex == 0
                    ? _buildCashPaymentButtons(constraints)
                    : _buildKpayPaymentButtons(constraints),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCashPaymentButtons(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      child: NumberButtons(
        defaultText: "0",
        formatNumber: true,
        enterClick: _handleCashPayment,
        numberController: _cashController,
        fullWidth: constraints.maxWidth,
        gridHeight: 76,
      ),
    );
  }

  Widget _buildKpayPaymentButtons(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      child: NumberButtons(
        defaultText: "0",
        formatNumber: true,
        enterClick: _handleKpayPayment,
        numberController: _cashController,
        fullWidth: constraints.maxWidth,
        gridHeight: 90,
      ),
    );
  }

  Widget _buildOrderSummary({
    required String menuName,
    required String tableNumber,
    required String spicyLevel,
    required String htoneLevel,
    required List<CartItem> items,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSectionHeader(tr(LocaleKeys.summary), IconlyLight.document),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMenuDetails(
                      htoneLevel: htoneLevel,
                      menuName: menuName,
                      spicyLevel: spicyLevel,
                      tableNumber: tableNumber,
                    ),
                    const SizedBox(height: 16),
                    _buildOrderItems(items),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPricingSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: context.primaryColor,
      ),
    );
  }

  Widget _buildMenuDetails({
    required String menuName,
    required String tableNumber,
    required String spicyLevel,
    required String htoneLevel,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primaryColor.withOpacity(0.05),
        borderRadius: SizeConst.kBorderRadius,
        border:
            Border.all(color: context.primaryColor.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Menu Type:", style: context.smallFont()),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: SizeConst.kBorderRadius,
                ),
                child: Text(menuName,
                    style: context.verySmall(
                        fontWeight: FontWeight.bold, color: context.cardColor)),
              ),
              const Spacer(),
              Text(
                "Table:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tableNumber,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "Spicy:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                spicyLevel,
                style: TextStyle(
                  fontSize: 14,
                  color: context.hintColor,
                ),
              ),
              const SizedBox(width: 32),
              Text(
                "Numbness:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                htoneLevel,
                style: TextStyle(
                  fontSize: 14,
                  color: context.hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(List<CartItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              tr(LocaleKeys.orderItems),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.hintColor,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                "${items.length} items",
                style: TextStyle(
                  fontSize: 12,
                  color: context.hintColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...items.map(
              (item) => Container(
                width: 270,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.hintColor.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.hintColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.isGram
                                ? "${item.qty} gram × ${(item.price).toStringAsFixed(0)} MMK"
                                : "${item.qty} piece × ${(item.price).toStringAsFixed(0)} MMK",
                            style: TextStyle(
                              fontSize: 12,
                              color: context.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${(item.totalPrice).toStringAsFixed(2)} MMK",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.transparent : Color(0xFFF7FAFC),
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: Column(
        children: [
          // Grand Total at the top for immediate visibility
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${tr(LocaleKeys.grandTotal)}:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.hintColor,
                ),
              ),
              Text(
                "$_grandTotal MMK",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          // Refund at the end
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${tr(LocaleKeys.refund)}:", style: context.normalFont()),
              Text(
                "${(_refundAmount).toStringAsFixed(0)} MMK",
                style: context.normalFont(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            color: context.hintColor,
            thickness: 0.5,
            height: 1,
          ),
          const SizedBox(height: 8),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${tr(LocaleKeys.subtotal)}:", style: context.normalFont()),
              Text(
                "${(_subTotal).toStringAsFixed(0)} MMK",
                style: context.normalFont(),
              ),
            ],
          ),

          // Tax (conditional)

          _customerTakeVoucher
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${tr(LocaleKeys.tax)}:", style: context.normalFont()),
                    Text(
                      "${get5percentage(_subTotal)} MMK",
                      style: context.normalFont(),
                    ),
                  ],
                )
              : Container(),

          // Payment breakdown

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${tr(LocaleKeys.onlinePay)}:", style: context.normalFont()),
              Text(
                "${(_paidOnline).toStringAsFixed(0)} MMK",
                style: context.normalFont(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${tr(LocaleKeys.cash)}:", style: context.normalFont()),
              Text(
                "${(_cashAmount).toStringAsFixed(0)} MMK",
                style: context.normalFont(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primaryColor.withOpacity(0.05),
        borderRadius: SizeConst.kBorderRadius,
        border: Border.all(color: context.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _customerTakeVoucher,
            onChanged: (value) => toggleVoucher(value),
            activeColor: context.primaryColor,
          ),
          const SizedBox(width: 8),
          Icon(Icons.local_offer, color: context.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LocaleKeys.applyVoucher),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.hintColor,
                  ),
                ),
                Text(
                  tr(LocaleKeys.voucherTaxNote),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
 void toggleVoucher(bool? value) {
    setState(() {
      _customerTakeVoucher = value ?? false;
      _calculateAmounts();
    });
  }
}
