import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/model/request_models/sale_request_model.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/view/pages/checkout_form.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

// ignore: must_be_immutable
class CashScreen extends StatefulWidget {
  CashScreen({
    super.key,
    required this.subTotal,
    required this.tax,
    required this.cashPayment,
    required this.athoneLevel,
    required this.spicyLevel,
    required this.dineInOrParcel,
    required this.menu_id,
    required this.table_number,
    required this.prawnCount,
    required this.octopusCount,
    required this.remark,
    required this.menu,
  });

  final int subTotal;
  final int tax;
  final bool cashPayment;
  final String remark;
  final int athoneLevel;
  final int spicyLevel;
  final int dineInOrParcel;
  final int menu_id;
  final String menu;
  final int table_number;
  final int prawnCount;
  final int octopusCount;

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  TextEditingController cashController = TextEditingController();

  num refundAmount = 0;
  int cashAmount = 0;
  int grandTotal = 0;
  int subTotal = 0;

  bool alreadyPrint = false;

  bool customerTakevoucher = true;

  @override
  void initState() {
    super.initState();
  }

  ScrollController categoryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);

    if (customerTakevoucher) {
      grandTotal = widget.subTotal + widget.tax;
    } else {
      grandTotal = widget.subTotal;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 160,
        leading: appBarLeading(onTap: () {
          Navigator.pop(context);
        }),
        title: Text("ငွေသားဖြင့်ပေးချေရန်"),
      ),
      body: InternetCheckWidget(
        child: _cashPaymentForm(screenSize, cartCubit),
        onRefresh: () {},
      ),
    );
  }

  ///cash payment form widget
  Widget _cashPaymentForm(Size screenSize, CartCubit cartCubit) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// left side of the screen
          _saleSummaryForm(screenSize, cartCubit),

          ///right side
          _numberButtonsForm(screenSize),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  Container _numberButtonsForm(Size screenSize) {
    return Container(
      height: 180,
      padding: EdgeInsets.only(
        top: 15,
        right: 15,
        left: 15,
        bottom: 15,
      ),
      margin: EdgeInsets.only(bottom: 15, right: SizeConst.kHorizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      width: screenSize.width * 0.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "ငွေပေးချေမှုနည်းလမ်း :",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "ငွေသား",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                child: custamizableElevated(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 7),
                      Text("အော်ဒါပြင်ရန်"),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  ///sale summary form
  Widget _saleSummaryForm(Size screenSize, CartCubit cartCubit) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConst.kHorizontalPadding,
          bottom: SizeConst.kHorizontalPadding,
          right: SizeConst.kHorizontalPadding,
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConst.kHorizontalPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: SizeConst.kBorderRadius,
          ),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "အကျဉ်းချုပ်",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Container(
                    height: screenSize.height * 0.45,
                    child: SingleChildScrollView(
                      
                      child: Column(
                        children: state.items
                            .map(
                              (e) => cartItemWidget(
                                ontapDisable: true,
                                cartItem: e,
                                screenSize: screenSize,
                                context: context,
                                onDelete: () {},
                                onEdit: () {},
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  ///total and tax widget
                  _cashAndCost(cartCubit: cartCubit),

                  Spacer(),
                  Row(
                    children: [
                      Checkbox(
                        value: customerTakevoucher,
                        activeColor: ColorConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            customerTakevoucher = value!;
                            checkProcess();
                          });
                        },
                      ),
                      Text("ဘောက်ချာယူမည်"),
                    ],
                  ),
                  SizedBox(height: 10),
                  _checkoutButton(
                    screenSize: screenSize,
                    cartItems: state.items,
                    cartCubit: cartCubit,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ///checkout button
  BlocBuilder _checkoutButton({
    required Size screenSize,
    required List<CartItem> cartItems,
    required CartCubit cartCubit,
  }) {
    return BlocBuilder<SaleProcessCubit, SaleProcessState>(
      builder: (context, state) {
        if (state is SaleProcessLoadingState) {
          return loadingWidget();
        } else {
          return custamizableElevated(
            enabled: true,
            width: double.infinity,
            elevation: 0,
            height: 70,
            child: Text("ငွေရှင်းရန်လုပ်ဆောင်ပါ"),
            onPressed: () async {
              ///*****///
              int discountAmount = 0;
              int taxAmount = 0;
              if (customerTakevoucher) {
                grandTotal = widget.subTotal + widget.tax;
                taxAmount = widget.tax;
                discountAmount = 0;
                subTotal = widget.subTotal;
              } else {
                grandTotal = widget.subTotal;
                subTotal = widget.subTotal;
                taxAmount = 0;
                discountAmount = widget.tax;
              }

              cashAmount = grandTotal;

              /// **********
              checkoutProcess(
                cartCubit: cartCubit,
                discountAmount: discountAmount,
                taxAmount: taxAmount,
                cartItems: cartItems,
              );
            },
          );
        }
      },
    );
  }

  ///generate random id
String generateRandomId(int length) {
  final Random random = Random();
  const int maxDigit = 9;

  String generateDigit() => random.nextInt(maxDigit + 1).toString();

  return List.generate(length, (_) => generateDigit()).join();
}

  ///***checkout process
  checkoutProcess({
    required CartCubit cartCubit,
    required int taxAmount,
    required int discountAmount,
    required List<CartItem> cartItems,
  }) async {

    
    if (cashAmount == grandTotal) {
      ///check conditions that if the curret sale process items is from pending orders or not
      DateTime dateTime = DateTime.now();
      SaleModel saleModel = SaleModel(
        octopusCount: widget.octopusCount,
        prawnCount: widget.prawnCount,
        remark: widget.remark,
        ahtone_level_id: widget.athoneLevel == 000 ? null : widget.athoneLevel,
        spicy_level_id: widget.spicyLevel == 000 ? null : widget.spicyLevel,
        dine_in_or_percel: widget.dineInOrParcel,
        grand_total: grandTotal,
        menu_id: widget.menu_id,
        order_no: "SS-${generateRandomId(6)}",
        paid_cash: grandTotal,
        products: context
            .read<CartCubit>()
            .state
            .items
            .map(
              (e) => Product(
                product_id: e.id,
                qty: e.qty,
                price: e.price,
                total_price: e.totalPrice,
              ),
            )
            .toList(),
        table_number: widget.table_number,
        refund: 0,
        sub_total: subTotal,
        tax: taxAmount,
        discount: discountAmount,
        paid_online: 0,
      );

      await context
          .read<SaleProcessCubit>()
          .makeSale(saleRequest: saleModel)
          .then(
        (value) {
          if (value) {
            redirectTo(
              context: context,
              form: CheckOutForm(
                customerTakevoucher: customerTakevoucher,
                octopusCount: cartCubit.state.octopusCount,
                prawnCount: cartCubit.state.prawnCount,
                taxAmount: taxAmount,
                saleData: saleModel,
                cartItems: cartItems,
                paymentType: "cash",
                dineInOrParcel: widget.dineInOrParcel,
                dateTime: DateFormat('dd, MMMM yyyy hh:mm a').format(dateTime),
                remark: widget.remark,
                menu: widget.menu,
                ahtoneLevel: cartCubit.state.athoneLevel,
                spicyLevel: cartCubit.state.spicyLevel,
                isEditSale: false,
              ),
              replacement: true,
            );
          } else {
            showCustomSnackbar(message: "Checkout Failed!", context: context);
          }
        },
      );
    }
  }

  ///totol cash and cost widget
  Widget _cashAndCost({required CartCubit cartCubit}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15, top: 5),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: ColorConstants.greyColor,
            ),
          ),
          SizedBox(height: 5),
          _amountRowWidget(
            amount: grandTotal,
            title: "GrandTotal",
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  ////widget to show the amount
  Row _amountRowWidget({
    required String title,
    required num amount,
    bool isChange = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "${title}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              isChange
                  ? "${formatNumber(amount)} MMK"
                  : "${formatNumber(amount)} MMK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isChange ? Colors.red : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// the process when clicking the enter button of the number buttons
  void enterClickProcess() {
    cashAmount =
        cashController.text.length > 0 ? int.parse(cashController.text) : 0;

    if (cashAmount > grandTotal) {
      refundAmount = cashAmount - grandTotal;
    } else if (cashAmount < grandTotal) {
      showSnackBar(
        text: "ငွေသားက မလုံလောက်ပါ",
        context: context,
      );
      cashAmount = 0;
      refundAmount = 0;
    }

    cashController.text = "";

    setState(() {});
  }

  ///check process that is customer is going to take voucher or not
  void checkProcess() {
    int grand_total = 0;
    if (customerTakevoucher) {
      grand_total = widget.subTotal + widget.tax;
    } else {
      grand_total = widget.subTotal;
    }
    if (cashAmount > grand_total) {
      refundAmount = cashAmount - grand_total;
    } else if (cashAmount < grand_total) {}

    cashController.text = "";

    setState(() {});
  }
}
