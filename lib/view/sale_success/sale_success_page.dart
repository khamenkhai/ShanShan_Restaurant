import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/home/home.dart';
import 'package:shan_shan/view/widgets/payment_edit_dialog.dart';
import 'package:shan_shan/view/widgets/voucher_widget.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

// ignore: must_be_immutable
class SaleSuccessPage extends StatefulWidget {
  SaleSuccessPage({
    super.key,
    required this.cartItems,
    required this.saleData,
    required this.dateTime,
    required this.taxAmount,
    required this.menuTitle,
    required this.ahtoneLevel,
    required this.spicyLevel,
    required this.paymentType,
    required this.customerTakevoucher,
    this.isEditSale = false,
  });

  final List<CartItem> cartItems;
  final SaleModel saleData;
  final String dateTime;
  final int taxAmount;
  final String menuTitle;
  final AhtoneLevelModel? ahtoneLevel;
  final SpicyLevelModel? spicyLevel;
  final bool customerTakevoucher;
  final bool isEditSale;

  String paymentType;

  @override
  State<SaleSuccessPage> createState() => _SaleSuccessPageState();
}

class _SaleSuccessPageState extends State<SaleSuccessPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().clearOrder();
    _initializePrinter();

    if (widget.customerTakevoucher) {
      _printTwice();
    } else {
      _printTwice();
    }
  }

  Future<void> _initializePrinter() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.paperSize();
    await SunmiPrinter.printerVersion();
    await SunmiPrinter.serialNumber();
  }

  Future<void> _printTwice() async {
    await _printReceipt();
    await _printReceipt();
  }

  Future<void> _printReceipt() async {
    await printReceipt(
      customerTakevoucher: widget.customerTakevoucher,
      paymentType: widget.paymentType,
      tableNumber: widget.saleData.tableNumber,
      menu: widget.menuTitle,
      ahtoneLevel: widget.ahtoneLevel?.name ?? "",
      spicyLevel: widget.spicyLevel?.name ?? "",
      remark: widget.saleData.remark ?? "",
      cashAmount: widget.saleData.paidCash,
      paidOnline: widget.saleData.paidOnline ?? 0,
      date: DateFormat('E d, MMM yyyy').format(DateTime.now()),
      discountAmount: widget.saleData.discount ?? 0,
      grandTotal: widget.saleData.grandTotal,
      subTotal: widget.saleData.subTotal,
      orderNumber: widget.saleData.orderNo,
      products: widget.cartItems,
      octopusCount: widget.saleData.octopusCount ?? 0,
      prawnCount: widget.saleData.prawnCount ?? 0,
      taxAmount: widget.taxAmount,
      dineInOrParcel: widget.saleData.dineInOrParcel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cartCubit = context.read<CartCubit>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _saleSuccessPage(screenSize),
              _voucherWidget(
                screenSize: screenSize,
                saleData: widget.saleData,
                cartCubit: cartCubit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saleSuccessPage(Size screenSize) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.saleSuccess.tr(),
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(50),
            height: 250,
            child: Lottie.asset(
              "assets/images/success.json",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 25),
          _processButtons(screenSize),
        ],
      ),
    );
  }

  Widget _processButtons(Size screenSize) {
    final buttonWidth = screenSize.width / 2.8;

    return Column(
      children: [
        SizedBox(
          width: buttonWidth,
          child: CustomElevatedButton(
            height: 60,
            onPressed: _printReceipt,
            child: Text(tr(LocaleKeys.printVoucher)),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: buttonWidth,
          child: CustomOutlineButton(
            height: 60,
            child: Text(
              LocaleKeys.editPayment.tr(),
              style: context.smallFont(
                  fontWeight: FontWeight.bold, color: context.textColor),
            ),
            onPressed: () async {
              final result = await showCupertinoDialog<String>(
                context: context,
                builder: (_) => PaymentEditDialog(
                  paymentType: widget.paymentType,
                  saleModel: widget.saleData,
                ),
              );

              if (result != null && result.isNotEmpty) {
                setState(() {
                  widget.paymentType = result;
                  if (result == "cash") {
                    widget.saleData.paidCash = widget.saleData.grandTotal;
                    widget.saleData.paidOnline = 0;
                  } else if (result == "Online Pay") {
                    widget.saleData.paidOnline = widget.saleData.grandTotal;
                    widget.saleData.paidCash = 0;
                  }
                });
              }
            },
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: buttonWidth,
          height: 60,
          child: widget.isEditSale
              ? CustomOutlineButton(
                  child: Text(
                    LocaleKeys.backToHistory.tr(),
                    style: context.smallFont(
                        fontWeight: FontWeight.bold, color: context.textColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<SalesHistoryCubit>()
                        .getHistoryByPagination(page: 1);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              : CustomOutlineButton(
                  child: Text(
                    LocaleKeys.makeNewOrder.tr(),
                    style: context.smallFont(
                        fontWeight: FontWeight.bold, color: context.textColor),
                  ),
                  onPressed: () {
                    pushAndRemoveUntil(form: HomeScreen(), context: context);
                  },
                ),
        ),
      ],
    );
  }

  Widget _voucherWidget({
    required Size screenSize,
    required SaleModel saleData,
    required CartCubit cartCubit,
  }) {
    return SizedBox(
      width: screenSize.width / 2.2,
      child: BlocBuilder<SaleProcessCubit, SaleProcessState>(
        builder: (context, state) {
          if (state is SaleProcessSuccessState) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(SizeConst.kGlobalMargin),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: VoucherWidget(
                      showEditButton: true,
                      paymentType: widget.paymentType,
                      tableNumber: saleData.tableNumber,
                      remark: widget.saleData.remark ?? "",
                      discount: saleData.discount ?? 0,
                      cashAmount: saleData.paidCash,
                      bankAmount: saleData.paidOnline ?? 0,
                      refund: saleData.refund,
                      subTotal: saleData.subTotal,
                      cartItems: widget.cartItems,
                      menu: widget.menuTitle,
                      date: widget.dateTime,
                      grandTotal: saleData.grandTotal,
                      orderNumber: saleData.orderNo,
                      octopusCount: widget.saleData.prawnCount ?? 0,
                      prawnAmount: widget.saleData.octopusCount ?? 0,
                      dineInOrParcel: widget.saleData.dineInOrParcel,
                      ahtoneLevel: widget.ahtoneLevel,
                      spicyLevel: widget.spicyLevel,
                    ),
                  ),
                ),
              ),
            );
          } else if (state is SaleProcessLoadingState) {
            return const LoadingWidget();
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
