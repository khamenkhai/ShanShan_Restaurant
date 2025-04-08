import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/service/local_noti_service.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/sale_success/sale_success_page.dart';
import 'package:shan_shan/view/home/widget/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/number_buttons.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key});

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
    final cartCubit = context.read<CartCubit>();
    subTotal = cartCubit.getTotalAmount();
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
      showSnackBar(text: "ငွေသားက မလုံလောက်ပါ", context: context);
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
    final cartCubit = BlocProvider.of<CartCubit>(context);

    calculateAmounts();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 160,
        leading: appBarLeading(onTap: () => Navigator.pop(context)),
        title: const Text("ငွေသားဖြင့်ပေးချေရန်"),
      ),
      body: InternetCheckWidget(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _saleSummaryForm(screenSize, cartCubit),
            _numberButtonsForm(screenSize),
            const SizedBox(width: 5),
          ],
        ),
        onRefresh: () {},
      ),
    );
  }

  Widget _saleSummaryForm(Size screenSize, CartCubit cartCubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(SizeConst.kHorizontalPadding),
        child: Container(
          padding: const EdgeInsets.all(SizeConst.kHorizontalPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: SizeConst.kBorderRadius,
          ),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "အကျဉ်းချုပ်",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor,
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
                        activeColor: ColorConstants.primaryColor,
                        onChanged: toggleVoucher,
                      ),
                      const Text("ဘောက်ချာယူမည်"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _checkoutButton(state.items, cartCubit),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _numberButtonsForm(Size screenSize) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(
          bottom: 15, right: SizeConst.kHorizontalPadding),
      width: screenSize.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text("ငွေပေးချေမှုနည်းလမ်း :",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 15),
                  Text("ငွေသား",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 50,
                child: CustomElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 7),
                      Text("အော်ဒါပြင်ရန်")
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
        _amountRowWidget(title: "GrandTotal", amount: grandTotal),
        const SizedBox(height: 5),
        if (refundAmount > 0)
          _amountRowWidget(
              title: "ပြန်အမ်းငွေ", amount: refundAmount, isChange: true),
      ],
    );
  }

  Widget _amountRowWidget(
      {required String title, required int amount, bool isChange = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(
          "${formatNumber(amount)} MMK",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isChange ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _checkoutButton(List<CartItem> cartItems, CartCubit cartCubit) {
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
          onPressed: () => _checkout(cartItems, cartCubit),
          child: const Text("ငွေရှင်းရန်လုပ်ဆောင်ပါ"),
        );
      },
    );
  }

  void _checkout(List<CartItem> cartItems, CartCubit cartCubit) async {
    if (cashAmount < grandTotal) {
      showSnackBar(text: "ငွေသားမလုံလောက်ပါ", context: context);
      return;
    }

    final dateTime = DateTime.now();
    final saleModel = SaleModel(
      octopusCount: cartCubit.state.octopusCount,
      prawnCount: cartCubit.state.prawnCount,
      remark: cartCubit.state.remark,
      ahtoneLevelId: cartCubit.state.athoneLevel?.id,
      spicyLevelId: cartCubit.state.spicyLevel?.id,
      dineInOrParcel: cartCubit.state.dineInOrParcel,
      grandTotal: grandTotal,
      menuId: cartCubit.state.menu?.id ?? 0,
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
      tableNumber: cartCubit.state.tableNumber,
      refund: refundAmount,
      subTotal: subTotal,
      tax: taxAmount,
      discount: 0,
      paidOnline: 0,
    );

    final success = await context.read<SaleProcessCubit>().makeSale(saleRequest: saleModel);

    if (!mounted) return;

    if (success) {
      LocalNotificationService().showNotification(title: "Sale Success!", body: "");
      NavigationHelper.pushReplacement(
        context,
        SaleSuccessPage(
          customerTakevoucher: customerTakesVoucher,
          taxAmount: taxAmount,
          saleData: saleModel,
          cartItems: cartItems,
          paymentType: "cash",
          dateTime: DateFormat('dd, MMMM yyyy hh:mm a').format(dateTime),
          menuTitle: cartCubit.state.menu!.name.toString(),
          ahtoneLevel: cartCubit.state.athoneLevel,
          spicyLevel: cartCubit.state.spicyLevel,
        ),
      );
    } else {
      showCustomSnackbar(message: "Checkout Failed!", context: context);
    }
  }

  String generateRandomId(int length) {
    final Random random = Random();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }
}
