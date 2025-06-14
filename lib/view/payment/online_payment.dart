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

class OnlinePaymentScreen extends StatefulWidget {
  const OnlinePaymentScreen({super.key});

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
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
        leading: AppBarLeading(onTap: () => Navigator.pop(context)),
        title: const Text("Online Payment"),
      ),
      body: InternetCheckWidget(
        child: _saleSummaryForm(screenSize, cartCubit),
        onRefresh: () {},
      ),
    );
  }

  Widget _saleSummaryForm(Size screenSize, CartCubit cartCubit) {
    return Center(
      child: Container(
        width: screenSize.width / 2,
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConst.kHorizontalPadding,
        ),
        margin: EdgeInsets.only(
          top: 5,
          bottom: SizeConst.kHorizontalPadding,
        ),
        child: Container(
          padding: const EdgeInsets.all(SizeConst.kHorizontalPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
                      "Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.5,
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
                  Divider(thickness: 0.5, color: ColorConstants.greyColor),
                  const SizedBox(height: 5),
                  _amountRowWidget(title: "GrandTotal", amount: grandTotal),
                  const Spacer(),
                  Row(
                    children: [
                      Checkbox(
                        value: customerTakesVoucher,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: toggleVoucher,
                      ),
                      Text(LocaleKeys.takeVoucher.tr()),
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

  Widget _amountRowWidget({required String title, required int amount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(
          "${formatNumber(amount)} MMK",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          onPressed: () => _checkout(cartItems, cartCubit),
          child: Text(tr(LocaleKeys.checkoutNow)),
        );
      },
    );
  }

  void _checkout(List<CartItem> cartItems, CartCubit cartCubit) async {
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
      paidCash: 0,
      paidOnline: grandTotal,
      products: cartItems
          .map((e) => Product(
                productId: e.id,
                qty: e.qty,
                price: e.price,
                totalPrice: e.totalPrice,
              ))
          .toList(),
      tableNumber: cartCubit.state.tableNumber,
      refund: 0,
      subTotal: subTotal,
      tax: taxAmount,
      discount: 0,
    );

    final success =
        await context.read<SaleProcessCubit>().makeSale(saleRequest: saleModel);

    if (!mounted) return;

    if (success) {
      LocalNotificationService()
          .showNotification(title: "Sale Success!", body: "");
      NavigationHelper.pushReplacement(
        context,
        SaleSuccessPage(
          customerTakevoucher: customerTakesVoucher,
          taxAmount: taxAmount,
          saleData: saleModel,
          cartItems: cartItems,
          paymentType: "online",
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
    return List.generate(
        length,
        (_) => (0 +
                (9 *
                    (1.0 * (DateTime.now().microsecondsSinceEpoch % 10)) ~/
                    10))
            .toString()).join();
  }
}
