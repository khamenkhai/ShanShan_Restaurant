import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/pages/checkout_form.dart';
import 'package:shan_shan/view/home/widget/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/date_action_widget.dart';
import 'package:shan_shan/view/widgets/number_buttons.dart';
import 'package:toggle_switch/toggle_switch.dart';

class KpayAndCashScreen extends StatefulWidget {
  const KpayAndCashScreen({
    super.key,
    required this.subTotal,
    required this.tax,
    required this.athoneLevel,
    required this.spicyLevel,
    required this.dineInOrParcel,
    required this.menuId,
    required this.tableNo,
    required this.prawnCount,
    required this.octopusCount,
    required this.menu,
    required this.remark,
  });

  final int subTotal;
  final int tax;
  final int athoneLevel;
  final int spicyLevel;
  final int dineInOrParcel;
  final int menuId;
  final int tableNo;
  final int prawnCount;
  final int octopusCount;
  final String remark;
  final String menu;

  @override
  State<KpayAndCashScreen> createState() => _KpayAndCashScreenState();
}

class _KpayAndCashScreenState extends State<KpayAndCashScreen> {
  bool showButtons = true;

  TextEditingController cashController = TextEditingController();

  int refundAmount = 0;
  int cashAmount = 0;
  int paidOnline = 0;
  int grandTotal = 0;

  bool alreadyPrint = false;

  bool customerTakevoucher = true;

  int paymentIndex = 0;

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
        actions: [
          DateActionWidget(),
          SizedBox(width: 25),
        ],
        title: Text("Cash & Kpay"),
      ),
      body: InternetCheckWidget(
        child: _paidCashForm(
          screenSize,
          cartCubit,
        ),
        onRefresh: () {},
      ),
    );
  }

  ///cash payment form widget
  Widget _paidCashForm(Size screenSize, CartCubit cartCubit) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// left side of the screen
          _saleSummaryForm(screenSize, cartCubit),

          ///right side
          _paymentTabsAndNumberButton(screenSize),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  /// payment tab and number button widgets
  Container _paymentTabsAndNumberButton(Size screenSize) {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        right: 15,
        left: 15,
        bottom: 20,
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
                    "ငွေပေးချေမှုနည်းလမ်းများ :",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  ToggleSwitch(
                    minWidth: 90.0,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: paymentIndex,
                    totalSwitches: 2,
                    labels: ['ငွေသား', 'Kpay'],
                    radiusStyle: true,
                    onToggle: (index) {
                      paymentIndex = index!;
                   
                      setState(() {});
                    },
                  ),
                ],
              ),
              Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(right: 15, top: 5),
                child: CustomElevatedButton(
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
              ),
              paymentIndex == 0
                  ? _paidCashButtons(constraints)
                  : Container(),
              paymentIndex == 1
                  ? _paidOnlineButtons(constraints)
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  /// cash amount payment button
  Container _paidCashButtons(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      decoration: BoxDecoration(),
      child: NumberButtons(
        defaultText: "0",
        formatNumber: true,
        enterClick: () {
          cashAddProcess();
        },
        numberController: cashController,
        fullWidth: constraints.maxWidth,
        gridHeight: 90,
      ),
    );
  }

  ///bank amount payment button
  Container _paidOnlineButtons(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      decoration: BoxDecoration(),
      child: NumberButtons(
        defaultText: "0",
        formatNumber: true,
        enterClick: () {
          kpayAddProcess();
        },
        numberController: cashController,
        fullWidth: constraints.maxWidth,
        gridHeight: 90,
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

                  SizedBox(
                    height: screenSize.height * 0.38,
                    child: SingleChildScrollView(
                      
                      child: Column(
                        children: state.items
                            .map(
                              (e) => CartItemWidget(
                                ontapDisable: true,
                                cartItem: e,
                             
                                onDelete: () {},
                                onEdit: () {},
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  ///total and tax widget
                  _cashAndCost(cartCubit: cartCubit),

                  Row(
                    children: [
                      Checkbox(
                        value: customerTakevoucher,
                        activeColor: ColorConstants.primaryColor,
                        onChanged: (value) {
                          customerTakevoucher = value!;
                          calculateRefund();
                        },
                      ),
                      //Text("Customer take voucher( no discount )"),
                      Text("ဘောက်ချာယူမည်"),
                    ],
                  ),
                  SizedBox(height: 5),
                  _checkoutButton(screenSize, state.items, cartCubit),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ///checkout button
  BlocBuilder _checkoutButton(
    Size screenSize,
    List<CartItem> cartItems,
    CartCubit cartCubit,
  ) {
    return BlocBuilder<SaleProcessCubit, SaleProcessState>(
      builder: (context, state) {
        if (state is SaleProcessLoadingState) {
          return LoadingWidget();
        } else {
          return CustomElevatedButton(
            isEnabled: isCheckoutEnabled(),
            width: double.infinity,
            elevation: 0,
            height: 70,
            child: Text("ငွေရှင်းရန်လုပ်ဆောင်ပါ"),
            onPressed: () async {
              int grandTotal = 0;
              int discountAmount = 0;
              int taxAmount = 0;
              if (customerTakevoucher) {
                grandTotal = widget.subTotal + widget.tax;
                taxAmount = widget.tax;
              } else {
                grandTotal = widget.subTotal;
                discountAmount = widget.tax;
                taxAmount = 0;
              }
              if (true) {
                ///check conditions that if the curret sale process items is from pending orders or not
                DateTime dateTime = DateTime.now();
                SaleModel saleModel = SaleModel(
                  octopusCount: widget.octopusCount,
                  prawnCount: widget.prawnCount,
                  remark: widget.remark,
                  ahtoneLevelId:
                      widget.athoneLevel == 000 ? null : widget.athoneLevel,
                  spicyLevelId:
                      widget.spicyLevel == 000 ? null : widget.spicyLevel,
                  dineInOrParcel: widget.dineInOrParcel,
                  grandTotal: grandTotal,
                  menuId: widget.menuId,
                  orderNo: "SS-${generateRandomId(6)}",
                  paidCash: cashAmount,
                  products: context
                      .read<CartCubit>()
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
                  tableNumber: widget.tableNo,
                  refund: refundAmount,
                  subTotal: widget.subTotal,
                  tax: taxAmount,
                  discount: discountAmount,
                  paidOnline: paidOnline,
                );
                await context
                    .read<SaleProcessCubit>()
                    .makeSale(
                      saleRequest: saleModel,
                    )
                    .then(
                  (value) {
                    if (value) {
                      if(!context.mounted) return;
                      redirectTo(
                        context: context,
                        form: CheckOutForm(
                          customerTakevoucher: customerTakevoucher,
                          ahtoneLevel: cartCubit.state.athoneLevel,
                          menu: widget.menu,
                          remark: widget.remark,
                          spicyLevel: cartCubit.state.spicyLevel,
                          octopusCount: widget.octopusCount,
                          prawnCount: widget.prawnCount,
                          taxAmount: taxAmount,
                          saleData: saleModel,
                          cartItems: cartItems,
                          dineInOrParcel: widget.dineInOrParcel,
                          paymentType: "Cash / Kpay",
                          dateTime: DateFormat('dd, MMMM yyyy hh:mm a')
                              .format(dateTime),
                          isEditSale: false,
                        ),
                        replacement: true,
                      );
                    } else {}
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  ///cash amount and cost widget
  Widget _cashAndCost({required CartCubit cartCubit}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 5),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: ColorConstants.greyColor,
            ),
          ),

          ///Kpay amount
          SizedBox(height: 5),
          _amountRowWidget(
            amount: paidOnline,
            title: "Kpay",
            isChange: false,
          ),

          ///cast

          SizedBox(height: 5),
          _amountRowWidget(
            amount: cashAmount,
            title: "ငွေသား",
          ),

          SizedBox(height: 5),
          _amountRowWidget(
            title: "Refund",
            amount: refundAmount,
            isChange: true,
          ),

          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Divider(
              height: 1,
            ),
          ),

          ///cost or grandtotal
          _amountRowWidget(amount: grandTotal, title: "GrandTotal"),
        ],
      ),
    );
  }

  ///grand total amount
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

  bool isCheckoutEnabled() {
    if ((cashAmount + paidOnline) >= grandTotal) {
      return true;
    } else {
      return false;
    }
  }

  ///cash adding process
  void cashAddProcess() {
    cashAmount =
        cashController.text.isNotEmpty ? int.parse(cashController.text) : 0;

    cashController.text = "0";

    calculateRefund();
  }

  ///Kpay adding process
  void kpayAddProcess() {
    paidOnline =
        cashController.text.isNotEmpty ? int.parse(cashController.text) : 0;
    cashController.text = "0";
    //paidOnline = grand_total - cashAmount;

    calculateRefund();
  }

  ///calculate refund
  calculateRefund() {
    int grandTotal = 0;
    if (customerTakevoucher) {
      grandTotal = widget.subTotal + widget.tax;
    } else {
      grandTotal = widget.subTotal;
    }
    if ((paidOnline + cashAmount) > grandTotal) {
      refundAmount = (paidOnline + cashAmount) - grandTotal;
    } else {
      refundAmount = 0;
    }
    setState(() {});
  }
}
