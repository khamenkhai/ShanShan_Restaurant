import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/view/home/home.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/payment_edit_dialog.dart';
import 'package:shan_shan/view/widgets/voucher_widget.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

// ignore: must_be_immutable
class CheckOutForm extends StatefulWidget {
  CheckOutForm({
    super.key,
    required this.cartItems,
    required this.saleData,
    required this.dateTime,
    required this.taxAmount,
    required this.dineInOrParcel,
    required this.prawnCount,
    required this.octopusCount,
    required this.remark,
    required this.menu,
    required this.ahtoneLevel,
    required this.spicyLevel,
    required this.paymentType,
    required this.customerTakevoucher,
    required this.isEditSale,
  });
  final List<CartItem> cartItems;
  final SaleModel saleData;
  final String dateTime;
  final int dineInOrParcel;
  final int prawnCount;
  final int octopusCount;
  final String remark;
  final int taxAmount;
  final String menu;
  final AhtoneLevelModel? ahtoneLevel;
  final SpicyLevelModel? spicyLevel;
  String paymentType;
  final bool customerTakevoucher;

  ///check if it's edit state
  final bool isEditSale;

  @override
  State<CheckOutForm> createState() => _CheckOutFormState();
}

class _CheckOutFormState extends State<CheckOutForm> {
  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  // bool printBinded = false;
  // int paperSize = 0;
  // String serialNumber = "";
  // String printerVersion = "";
  // bool alreadyPrint = false;

  @override
  void initState() {
    super.initState();

    context.read<CartCubit>().clearOrderr();

    ///initialize sunmi printer
    _initializePrinter();

    if (widget.customerTakevoucher) {
      _printTwice();
    } else {
      _printTwice();
    }
  }

  void _initializePrinter() {
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {});

      SunmiPrinter.printerVersion().then((String version) {});

      SunmiPrinter.serialNumber().then((String serial) {});
    });
  }

  Future _printTwice() async {
    await _printReceipt();
    await _printReceipt();
  }

  Future _printReceipt() async {
    await printReceipt(
      customerTakevoucher: widget.customerTakevoucher,
      paymentType: widget.paymentType,
      tableNumber: widget.saleData.tableNumber,
      menu: widget.menu,
      ahtoneLevel:
          widget.ahtoneLevel == null ? "" : "${widget.ahtoneLevel!.name}",
      spicyLevel:
          widget.spicyLevel == null ? "" : widget.spicyLevel!.name ?? "",
      remark: "${widget.remark}",
      cashAmount: widget.saleData.paidCash,
      paidOnline: widget.saleData.paidOnline,
      date: "${DateFormat('E d, MMM yyyy').format(DateTime.now())}",
      discountAmount: widget.saleData.discount,
      grandTotal: widget.saleData.grandTotal,
      subTotal: widget.saleData.subTotal,
      orderNumber: widget.saleData.orderNo,
      products: widget.cartItems,
      octopusCount: widget.octopusCount,
      prawnCount: widget.prawnCount,
      taxAmount: widget.taxAmount,
      dineInOrParcel: widget.dineInOrParcel,
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///left side
              _saleSuccessForm(context, screenSize),

              ///right side
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

  Container _saleSuccessForm(BuildContext context, Size screenSize) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      padding: EdgeInsets.all(15 + 20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "အရောင်းအောင်မြင်ပါသည်",
                style: TextStyle(
                  fontSize: 16 + 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 25),
            ],
          ),
          SizedBox(height: 25),
          SizedBox(
            height: 250,
            child: Image.asset(
              "assets/images/cashier.png",
            ),
          ),
          SizedBox(height: 65),
          _processButtons(screenSize, context),
        ],
      ),
    );
  }

  ///process bu8ttons
  Widget _processButtons(Size screenSize, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: (screenSize.width / 2.8),
          height: 60,
          child: CustomElevatedButton(
            child: Text("ဘောက်ချာထုတ်ယူရန်"),
            onPressed: () async {
              _printReceipt();
            },
          ),
        ),
        SizedBox(
          width: (screenSize.width / 2.8),
          height: 60,
          child: customizableOTButton(
            child: Text("ငွေပေးချေမှုကို edit လုပ်ရန်"),
            onPressed: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return PaymentEditDialog(
                    paymentType: widget.paymentType,
                    saleModel: widget.saleData,
                  );
                },
              );

              if (result != null || result != "") {
                widget.paymentType = result ?? "";

                if (result == "cash") {
                  widget.saleData.paidCash = widget.saleData.grandTotal;
                  widget.saleData.paidOnline = 0;
                } else if (result == "Kpay") {
                  widget.saleData.paidOnline = widget.saleData.grandTotal;
                  widget.saleData.paidCash = 0;
                }
              }
            },
          ),
        ),
        SizedBox(
          width: (screenSize.width / 2.8),
          height: 60,
          child: widget.isEditSale
              ? customizableOTButton(
                  child: Text("အရောင်းမှတ်တမ်းသို့ ပြန်သွားရန်"),
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<SalesHistoryCubit>()
                        .getHistoryByPagination(page: 1);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              : customizableOTButton(
                  child: Text("အသစ်မှာယူရန်"),
                  onPressed: () {
                    pushAndRemoveUntil(
                      form: HomeScreen(),
                      context: context,
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// voucher widget to show the sale voucher
  Widget _voucherWidget({
    required Size screenSize,
    required SaleModel saleData,
    required CartCubit cartCubit,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 15 + 20,
          right: 15 + 20,
          top: SizeConst.kHorizontalPadding,
        ),
        child: BlocBuilder<SaleProcessCubit, SaleProcessState>(
          builder: (context, state) {
            if (state is SaleProcessSuccessState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    VoucherWidget(
                      showEditButton: true,
                      paymentType: widget.paymentType,
                      tableNumber: saleData.tableNumber,
                      remark: widget.remark,
                      discount: saleData.discount,
                      cashAmount: saleData.paidCash,
                      bankAmount: saleData.paidOnline,
                      change: saleData.refund,
                      subTotal: saleData.subTotal,
                      cartItems: widget.cartItems,
                      menu: widget.menu,
                      date: widget.dateTime,
                      grandTotal: saleData.grandTotal,
                      orderNumber: saleData.orderNo,
                      octopusCount: widget.prawnCount,
                      prawnAmount: widget.octopusCount,
                      dineInOrParcel: widget.dineInOrParcel,
                      ahtoneLevel: widget.ahtoneLevel,
                      spicyLevel: widget.spicyLevel,
                    ),
                  ],
                ),
              );
            } else if (state is SaleProcessLoadingState) {
              return LoadingWidget();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  ///to remove the .0 in the numbers
  String removeZero(String number) {
    String numStr = number;
    if (numStr.endsWith('.0')) {
      numStr = numStr.substring(0, numStr.length - 2);
    }
    return numStr;
  }

  int? getPaidAmount() {
    if (widget.paymentType == "cash") {
      return widget.saleData.paidCash;
    } else if (widget.paymentType == "Kpay") {
      return widget.saleData.paidOnline;
    } else {
      return widget.saleData.paidOnline + widget.saleData.paidCash;
    }
  }
}
