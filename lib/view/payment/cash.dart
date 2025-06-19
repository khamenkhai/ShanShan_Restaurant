import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/service/local_noti_service.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/sale_success/sale_success_page.dart';
import 'package:shan_shan/view/home/widget/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/number_buttons.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key,required this.isEditState});
  final bool isEditState;

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  final TextEditingController cashController = TextEditingController();
  final ScrollController categoryScrollController = ScrollController();

  int cashAmount = 0;
  int refundAmount = 0;
  int subTotal = 0;
  int taxAmount = 0;
  int grandTotal = 0;

  bool customerTakesVoucher = true;

  @override
  void initState() {
    super.initState();
    calculateAmounts();
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

  void enterClickProcess() {
    final enteredCash = int.tryParse(cashController.text) ?? 0;

    if (enteredCash < grandTotal) {
      showSnackBar(text: LocaleKeys.cashNotEnough.tr(), context: context);
      return;
    }

    setState(() {
      cashAmount = enteredCash;
      refundAmount = cashAmount - grandTotal;
      cashController.clear();
    });
  }

  void toggleVoucher(bool? value) {
    setState(() {
      customerTakesVoucher = value ?? true;
      calculateAmounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cartController = BlocProvider.of<CartCubit>(context);

    calculateAmounts();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 160,
        leading: AppBarLeading(onTap: () => Navigator.pop(context)),
        title: Text(LocaleKeys.cashTitle.tr()),
      ),
      body: InternetCheckWidget(
        child: Container(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _saleSummaryForm(screenSize, cartController),
              const SizedBox(width: SizeConst.kGlobalPadding),
              _numberButtonsForm(screenSize),
            ],
          ),
        ),
        onRefresh: () {},
      ),
    );
  }

  Widget _saleSummaryForm(Size screenSize, CartCubit cartController) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(SizeConst.kGlobalPadding),
        margin: EdgeInsets.only(left: SizeConst.kGlobalPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    LocaleKeys.summary.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.45,
                  child: SingleChildScrollView(
                    child: Column(
                      children: state.items
                          .map((e) => CartItemWidget(
                                ontapDisable: true,
                                cartItem: e,
                                onDelete: () {},
                                onEdit: () {},
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _cashAndCost(),
                const Spacer(),
                Row(
                  children: [
                    Checkbox(
                      value: customerTakesVoucher,
                      onChanged: toggleVoucher,
                    ),
                    Text(LocaleKeys.takeVoucher.tr()),
                  ],
                ),
                const SizedBox(height: 10),
                _checkoutButton(state.items, cartController),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _numberButtonsForm(Size screenSize) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(
        bottom: 15,
        right: SizeConst.kGlobalPadding,
      ),
      width: screenSize.width * 0.5,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    LocaleKeys.paymentMethod.tr(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    LocaleKeys.cash.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 50,
                child: CustomElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 7),
                      Text(LocaleKeys.editOrder.tr()),
                    ],
                  ),
                ),
              ),
              NumberButtons(
                defaultText: "0",
                formatNumber: true,
                enterClick: enterClickProcess,
                numberController: cashController,
                fullWidth: constraints.maxWidth,
                gridHeight: 90,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cashAndCost() {
    return Column(
      children: [
        Divider(thickness: 0.5, color: ColorConstants.greyColor),
        const SizedBox(height: 5),
        _amountRowWidget(title: LocaleKeys.grandTotal.tr(), amount: grandTotal),
        _amountRowWidget(
            title: LocaleKeys.totalPaidCash.tr(), amount: cashAmount),
        const SizedBox(height: 5),
        if (refundAmount > 0)
          _amountRowWidget(
            title: LocaleKeys.refund.tr(),
            amount: refundAmount,
            isChange: true,
          ),
      ],
    );
  }

  Widget _amountRowWidget({
    required String title,
    required int amount,
    bool isChange = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          "${formatNumber(amount)} MMK",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isChange ? Colors.red : null,
          ),
        ),
      ],
    );
  }

  Widget _checkoutButton(List<CartItem> cartItems, CartCubit cartController) {
    return BlocConsumer<SaleProcessCubit, SaleProcessState>(
      listener: (context, state) {
        if (state is SaleProcessSuccessState) {}
      },
      builder: (context, state) {
        if (state is SaleProcessLoadingState) return const LoadingWidget();

        return CustomElevatedButton(
          isEnabled: true,
          width: double.infinity,
          elevation: 0,
          height: 70,
          onPressed: () => _checkout(cartItems, cartController),
          child: Text(LocaleKeys.checkoutNow.tr()),
        );
      },
    );
  }

  void _checkout(List<CartItem> cartItems, CartCubit cartController) async {
    if (cashAmount < grandTotal) {
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
      paidCash: cashAmount,
      products: cartItems
          .map((e) => Product(
                productId: e.id,
                qty: e.qty,
                price: e.price,
                totalPrice: e.totalPrice,
              ))
          .toList(),
      tableNumber: cartController.state.tableNumber,
      refund: refundAmount,
      subTotal: subTotal,
      tax: taxAmount,
      discount: 0,
      paidOnline: 0,
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
          paymentType: "cash",
          dateTime: DateFormat('dd, MMMM yyyy hh:mm a').format(dateTime),
          menuTitle: cartController.state.menu!.name.toString(),
          ahtoneLevel: cartController.state.athoneLevel,
          spicyLevel: cartController.state.spicyLevel,
        ),
      );
    } else {
      showCustomSnackbar(
        message: LocaleKeys.checkoutFailed.tr(),
        context: context,
      );
    }
  }

  String generateRandomId(int length) {
    final Random random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }
}
