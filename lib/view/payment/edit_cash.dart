import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
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

class EditCashScreen extends StatefulWidget {
  const EditCashScreen({
    super.key,
    required this.subTotal,
    required this.tax,
    required this.paidCash,
    required this.athoneLevel,
    required this.spicyLevel,
    required this.dineInOrParcel,
    required this.menuId,
    required this.tableNumber,
    required this.prawnCount,
    required this.octopusCount,
    required this.remark,
    required this.menu,
    required this.orderNo,
    required this.date,
  });

  final int subTotal;
  final int tax;
  final bool paidCash;
  final String remark;
  final int athoneLevel;
  final int spicyLevel;
  final int dineInOrParcel;
  final int menuId;
  final String menu;
  final int tableNumber;
  final String orderNo;
  final int prawnCount;
  final int octopusCount;
  final String date;

  @override
  State<EditCashScreen> createState() => _EditCashScreenState();
}

class _EditCashScreenState extends State<EditCashScreen> {
  bool showButtons = true;

  TextEditingController cashController = TextEditingController();

  num refundAmount = 0;
  int cashAmount = 0;
  int grandTotal = 0;
  int subTotal = 0;

  bool alreadyPrint = false;

  bool customerTakevoucher = true;

  int taxAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  ScrollController categoryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    EditSaleCartCubit cartCubit = BlocProvider.of<EditSaleCartCubit>(context);

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
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: _paidCashForm(
                screenSize,
                cartCubit,
              ),
            ),
            onRefresh: () {}));
  }

  ///cash payment form widget
  Widget _paidCashForm(Size screenSize, EditSaleCartCubit cartCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// left side of the screen
        _saleSummaryForm(screenSize, cartCubit),

        ///right side
        Container(
          height: 180,
          padding: EdgeInsets.only(
            top: 15,
            right: 15,
            left: 15,
            bottom: 15,
          ),
          margin:
              EdgeInsets.only(bottom: 15, right: SizeConst.kHorizontalPadding),
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
                  //_abc(),
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
                  )
                ],
              );
            },
          ),
        ),
        SizedBox(width: 5),
      ],
    );
  }

  ///sale summary form
  Widget _saleSummaryForm(Size screenSize, EditSaleCartCubit cartCubit) {
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
          child: BlocBuilder<EditSaleCartCubit, EditSaleCartState>(
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
                    height: screenSize.height * 0.45,
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
                            // refundAmount = 0;
                            // cashAmount = 0;
                            checkProcess();
                          });
                        },
                      ),
                      //Text("Customer take voucher( no discount )"),
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
    required EditSaleCartCubit cartCubit,
  }) {
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
              int discountAmount = 0;
              if (customerTakevoucher) {
                grandTotal = widget.subTotal + widget.tax;
                subTotal = widget.subTotal;
                taxAmount = widget.tax;
              } else {
                grandTotal = widget.subTotal;
                subTotal = widget.subTotal;
                discountAmount = widget.tax;
                taxAmount = 0;
              }

              cashAmount = grandTotal;

              /// **********
              if (cashAmount == grandTotal) {
                ///check conditions that if the curret sale process items is from pending orders or not

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
                  orderNo: "${widget.orderNo}",
                  paidCash: grandTotal,
                  products: context
                      .read<EditSaleCartCubit>()
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
                  tableNumber: widget.tableNumber,
                  refund: 0,
                  subTotal: subTotal,
                  tax: taxAmount,
                  discount: discountAmount,
                  paidOnline: 0,
                );

                await context
                    .read<SaleProcessCubit>()
                    .updateSale(
                      saleRequest: saleModel,
                      orderId: saleModel.orderNo,
                    )
                    .then(
                  (value) {
                    if (value) {
                      if (!context.mounted) return;
                      redirectTo(
                        context: context,
                        form: CheckOutForm(
                          customerTakevoucher: customerTakevoucher,
                          taxAmount: taxAmount,
                          saleData: saleModel,
                          cartItems: cartItems,
                          paymentType: "cash",
                          dateTime: widget.date,
                          menuTitle: widget.menu,
                          ahtoneLevel: cartCubit.state.athoneLevel,
                          spicyLevel: cartCubit.state.spicyLevel,
                          isEditSale: true,
                        ),
                        replacement: true,
                      );
                    } else {
                      if (!context.mounted) return;
                      showCustomSnackbar(
                          message: "Checkout Failed!", context: context);
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _cashAndCost({required EditSaleCartCubit cartCubit}) {
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
          // _amountRowWidget(
          //   amount: cashAmount,
          //   title: "Cash",
          // ),
          // SizedBox(height: 5),
          // _amountRowWidget(
          //   title: "Refund",
          //   amount: refundAmount,
          //   isChange: true,
          // ),
        ],
      ),
    );
  }

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
    return true;

    ///**********
    // if ((cashAmount > 0 && cashAmount >= widget.subTotal)) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  void enterClickProcess() {
    cashAmount =
        cashController.text.isNotEmpty ? int.parse(cashController.text) : 0;

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

  void checkProcess() {
    int grandTotal = 0;
    if (customerTakevoucher) {
      grandTotal = widget.subTotal + widget.tax;
    } else {
      grandTotal = widget.subTotal;
    }
    if (cashAmount > grandTotal) {
      refundAmount = cashAmount - grandTotal;
    } else if (cashAmount < grandTotal) {
      // cashAmount = 0;
      // refundAmount = 0;
    }

    cashController.text = "";

    setState(() {});
  }

  ///calculate refund
  calculateRefund() {
    // if ((paidOnline + cashAmount) > grand_total) {
    //   refundAmount = (paidOnline + cashAmount) - grand_total;
    // } else {
    //   refundAmount = 0;
    // }
    setState(() {});
  }
}
