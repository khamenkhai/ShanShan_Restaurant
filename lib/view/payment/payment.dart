import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/component/scale_on_tap.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/service/local_noti_service.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/sale_success/sale_success_page.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.isEditState});
  final bool isEditState;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController cashController = TextEditingController();
  final ScrollController categoryScrollController = ScrollController();

  int cashAmount = 0;
  int refundAmount = 0;
  int subTotal = 0;
  int taxAmount = 0;
  int grandTotal = 0;

  bool customerTakesVoucher = false;
  String selectedPaymentMethod = "cash";

  // Modern color scheme matching the image

  static const Color textSecondary = Color(0xFF718096);

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    if (widget.isEditState) {
      calculateAmountsForEditState();
    } else {
      calculateAmounts();
    }
    setState(() {});
  }

  void calculateAmounts() {
    final cart = context.read<CartCubit>();
    subTotal = cart.getTotalAmount();
    taxAmount = customerTakesVoucher ? get5percentage(subTotal) : 0;
    grandTotal = subTotal + taxAmount;

    if (cashAmount > grandTotal) {
      refundAmount = cashAmount - grandTotal;
    } else {
      refundAmount = 0;
    }
  }

  void calculateAmountsForEditState() {
    final cart = context.read<OrderEditCubit>();
    subTotal = cart.getTotalAmount();
    taxAmount = customerTakesVoucher ? get5percentage(subTotal) : 0;
    grandTotal = subTotal + taxAmount;

    if (cashAmount > grandTotal) {
      refundAmount = cashAmount - grandTotal;
    } else {
      refundAmount = 0;
    }
  }

  void enterClickProcess() {
    final enteredCash = int.tryParse(cashController.text) ?? 0;

    setState(() {
      cashAmount = enteredCash;
      refundAmount = cashAmount - grandTotal;
      cashController.clear();
    });
  }

  void toggleVoucher(bool? value) {
    setState(() {
      customerTakesVoucher = value ?? false;
      calculateAmounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cartController = BlocProvider.of<CartCubit>(context);
    final editCart = BlocProvider.of<OrderEditCubit>(context);

    // ...
    if (widget.isEditState) {
      calculateAmountsForEditState();
    } else {
      calculateAmounts();
    }

    return Scaffold(
      body: SafeArea(
        child: InternetCheckWidget(
          child: Container(
            margin: EdgeInsets.all(SizeConst.kGlobalMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarLeading(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildOrderSummary(
                          items: widget.isEditState
                              ? editCart.state.items
                              : cartController.state.items,
                          menuName: widget.isEditState
                              ? editCart.state.menu?.name ?? ""
                              : cartController.state.menu?.name ?? "",
                          tableNumber: widget.isEditState
                              ? editCart.state.tableNumber.toString()
                              : cartController.state.tableNumber.toString(),
                          spicyLevel: widget.isEditState
                              ? editCart.state.spicyLevel?.name ?? ""
                              : cartController.state.spicyLevel?.name ?? "",
                          htoneLevel: widget.isEditState
                              ? editCart.state.athoneLevel?.name ?? ""
                              : cartController.state.athoneLevel?.name ?? "",
                        ),
                      ),
                      const SizedBox(width: SizeConst.kGlobalMargin),
                      Expanded(child: _buildPaymentDetails(screenSize)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onRefresh: () {},
        ),
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
            const SizedBox(height: 16),
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

  Widget _buildPaymentDetails(Size screenSize) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                  tr(LocaleKeys.paymentDetails), IconlyLight.wallet),
              const SizedBox(height: 16),
              _buildVoucherSection(),
              const SizedBox(height: 16),
              _buildPaymentMethodSection(),
              const SizedBox(height: 16),
              if (selectedPaymentMethod == "cash")
                _buildAmountReceivedSection(),
              // const Spacer(),
              _buildCompletePaymentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.primaryColor,
          ),
        ),
      ],
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
                  color: textSecondary,
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
                  color: textSecondary,
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
                  color: textSecondary,
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
                  color: textSecondary,
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
                            item.isGram ? "${item.qty} gram × ${(item.price).toStringAsFixed(0)} MMK":
                            "${item.qty} piece × ${(item.price).toStringAsFixed(0)} MMK",
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${tr(LocaleKeys.subtotal)}:", style: context.normalFont()),
              Text(
                "${(subTotal).toStringAsFixed(0)} MMK",
                style: context.normalFont(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          customerTakesVoucher
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tax:", style: context.normalFont()),
                    Text(
                      "${get5percentage(subTotal)} MMK",
                      style: context.normalFont(),
                    ),
                  ],
                )
              : Container(),
          const SizedBox(height: 16),
          Divider(
            color: context.hintColor,
            thickness: 0.5,
            height: 1,
          ),
          const SizedBox(height: 16),
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
                "$grandTotal MMK",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              )
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
            value: customerTakesVoucher,
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
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LocaleKeys.paymentMethod),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.hintColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildPaymentOption(
              "cash",
              tr(LocaleKeys.cash),
              "Pay with physical cash",
              const Color(0xFF48BB78),
              selectedPaymentMethod == "cash",
            ),
            const SizedBox(width: 12),
            _buildPaymentOption(
              "online",
              tr(LocaleKeys.onlinePay),
              "Card or digital wallet",
              const Color(0xFF4299E1),
              selectedPaymentMethod == "online",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    Color iconColor,
    bool isSelected,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: SizeConst.kBorderRadius,
          border: Border.all(
            color: isSelected
                ? context.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: (newValue) {
                selectedPaymentMethod = newValue!;
                if (selectedPaymentMethod == "online") {
                  refundAmount = 0;
                }
                setState(() {});
              },
              activeColor: context.primaryColor,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.hintColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountReceivedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LocaleKeys.amountReceived),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.hintColor,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: cashController,
          keyboardType: TextInputType.number,
          onSubmitted: (value) {
            enterClickProcess();
          },
          decoration: InputDecoration(
            hintText: "Cash: $cashAmount MMK",
            hintStyle: TextStyle(color: textSecondary),
            border: OutlineInputBorder(
              borderRadius: SizeConst.kBorderRadius,
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: SizeConst.kBorderRadius,
              borderSide: BorderSide(color: context.primaryColor),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.hintColor,
          ),
        ),
        const SizedBox(height: 16),

        // const SizedBox(height: 16),
        if (refundAmount > 0)
          Container(
            padding: const EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FFF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC6F6D5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${tr(LocaleKeys.changeAmount)}:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF22543D),
                  ),
                ),
                Text(
                  "$refundAmount MMK",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF22543D),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCompletePaymentButton() {
    return BlocConsumer<SaleProcessCubit, SaleProcessState>(
      listener: (context, state) {
        if (state is SaleProcessSuccessState) {}
      },
      builder: (context, state) {
        final cartController = BlocProvider.of<CartCubit>(context);

        if (state is SaleProcessLoadingState) {
          return Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(0.7),
              borderRadius: SizeConst.kBorderRadius,
            ),
            child: const Center(child: LoadingWidget()),
          );
        }

        return CustomElevatedButton(
          width: double.infinity,
          height: 56,
          onPressed: () {
            if (widget.isEditState) {
              _editSale(
                context.read<OrderEditCubit>(),
              );
            } else {
              _checkout(cartController.state.items, cartController);
            }
          },
          child: Text(widget.isEditState
              ? tr(LocaleKeys.update)
              : tr(LocaleKeys.checkout)),
        );
      },
    );
  }

  void _checkout(List<CartItem> cartItems, CartCubit cartController) async {
    if (selectedPaymentMethod == "cash" && cashAmount < grandTotal) {
      showSnackBar(text: LocaleKeys.cashInsufficient.tr(), context: context);
      return;
    }

    final dateTime = DateTime.now();
    final saleModel = SaleModel(
      octopusCount: cartController.state.octopusCount,
      prawnCount: cartController.state.prawnCount,
      remark: cartController.state.remark,
      ahtoneLevelId: cartController.state.athoneLevel?.id,
      spicyLevelId: cartController.state.spicyLevel?.id,
      dineInOrParcel: cartController.state.dineInOrParcel,
      grandTotal: grandTotal,
      menuId: cartController.state.menu?.id ?? 0,
      orderNo: "SS-${generateRandomId(6)}",
      paidCash: selectedPaymentMethod == "cash" ? cashAmount : 0,
      products: cartItems
          .map(
            (e) => Product(
              productId: e.id,
              qty: e.qty,
              price: e.price,
              totalPrice: e.totalPrice,
            ),
          )
          .toList(),
      tableNumber: cartController.state.tableNumber,
      refund: refundAmount,
      subTotal: subTotal,
      tax: taxAmount,
      discount: 0,
      paidOnline: selectedPaymentMethod == "online" ? grandTotal : 0,
    );

    final success =
        await context.read<SaleProcessCubit>().makeSale(saleRequest: saleModel);

    if (!mounted) return;

    if (success) {
      LocalNotificationService()
          .showNotification(title: LocaleKeys.saleSuccess.tr(), body: "");
      NavigationHelper.pushReplacement(
        context,
        SaleSuccessPage(
          customerTakevoucher: customerTakesVoucher,
          taxAmount: taxAmount,
          saleData: saleModel,
          cartItems: cartItems,
          paymentType: selectedPaymentMethod,
          dateTime: DateFormat('dd, MMMM yyyy hh:mm a').format(dateTime),
          menuTitle: cartController.state.menu!.name.toString(),
          ahtoneLevel: cartController.state.athoneLevel,
          spicyLevel: cartController.state.spicyLevel,
        ),
      );
    } else {
      showCustomSnackbar(
        message: LocaleKeys.checkoutFailed.tr(),
      );
    }
  }

  void _editSale(OrderEditCubit editCart) async {
    if (selectedPaymentMethod == "cash" && cashAmount < grandTotal) {
      showSnackBar(text: LocaleKeys.cashInsufficient.tr(), context: context);
      return;
    }

    ///check conditions that if the curret sale process items is from pending orders or not
    final cart = editCart.state;
    SaleModel saleModel = SaleModel(
      octopusCount: cart.octopusCount,
      prawnCount: cart.prawnCount,
      remark: cart.remark,
      ahtoneLevelId: cart.athoneLevel?.id,
      spicyLevelId: cart.spicyLevel?.id,
      dineInOrParcel: cart.dineInOrParcel,
      grandTotal: grandTotal,
      menuId: cart.menu?.id ?? 0,
      orderNo: cart.orderNo,
      paidCash: grandTotal,
      products: context
          .read<OrderEditCubit>()
          .state
          .items
          .map(
            (e) => Product(
              productId: e.id,
              qty: e.qty,
              price: e.price,
              totalPrice: e.totalPrice,
            ),
          )
          .toList(),
      tableNumber: cart.tableNumber,
      refund: 0,
      subTotal: subTotal,
      tax: taxAmount,
      discount: 0,
      paidOnline: 0,
    );

    await context
        .read<SaleProcessCubit>()
        .updateSale(
          saleRequest: saleModel,
        )
        .then(
      (value) {
        if (value) {
          if (!mounted) return;
          NavigationHelper.pushReplacement(
            context,
            SaleSuccessPage(
              customerTakevoucher: customerTakesVoucher,
              taxAmount: taxAmount,
              saleData: saleModel,
              cartItems: cart.items,
              paymentType: selectedPaymentMethod,
              dateTime: cart.date,
              menuTitle: cart.menu?.name.toString() ?? "",
              ahtoneLevel: cart.athoneLevel,
              spicyLevel: cart.spicyLevel,
              isEditSale: true,
            ),
          );
        } else {
          if (!context.mounted) return;
          showCustomSnackbar(message: tr(LocaleKeys.checkoutFailed));
        }
      },
    );
  }

  String generateRandomId(int length) {
    final Random random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }
}

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({
    super.key,
    required this.onTap,
    this.padding = SizeConst.kGlobalPadding,
  });
  final VoidCallback onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: Center(
          child: Icon(
            IconlyBold.arrow_left_2,
          ),
        ),
      ),
    );
  }
}
