import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/view/sale_success/sale_success_page.dart';
import 'package:shan_shan/view/home/widget/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/number_buttons.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditMultiPaymentPage extends StatefulWidget {
  const EditMultiPaymentPage({
    super.key,
    required this.subTotal,
    required this.tax,
    required this.athoneLevel,
    required this.spicyLevel,
    required this.dineInOrParcel,
    required this.menuId,
    required this.tableNumber,
    required this.prawnCount,
    required this.octopusCount,
    required this.menu,
    required this.remark,
    required this.orderNo,
    required this.date,
  });

  final int subTotal;
  final int tax;
  final int athoneLevel;
  final int spicyLevel;
  final int dineInOrParcel;
  final int menuId;
  final int tableNumber;
  final int prawnCount;
  final int octopusCount;
  final String remark;
  final String menu;
  final String orderNo;
  final String date;

  @override
  State<EditMultiPaymentPage> createState() => _EditMultiPaymentPageState();
}

class _EditMultiPaymentPageState extends State<EditMultiPaymentPage> {
  bool showButtons = true;

  TextEditingController cashController = TextEditingController();

  int refundAmount = 0;
  int cashAmount = 0;
  int paidOnline = 0;
  int grandTotal = 0;
  int discountAmount = 0;
  int taxAmount = 0;

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
        leading: AppBarLeading(onTap: () {
          Navigator.pop(context);
        }),
        title: Text("Cash & Online Pay"),
        actions: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: SizeConst.kBorderRadius,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.orderNo,
                    style: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontSize: 20 - 4,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(CupertinoIcons.shopping_cart)
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body:Container(
              padding: EdgeInsets.only(top: 15),
              child: _paidCashForm(
                screenSize,
                cartCubit,
              ),
            ),
    );
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
                        labels: ['ငွေသား', 'Online Pay'],
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
                    margin: EdgeInsets.only(right: 15, top: 20),
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
        ),
        SizedBox(width: 5),
      ],
    );
  }

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

  Container _paidOnlineButtons(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      decoration: BoxDecoration(),
      child: NumberButtons(
        defaultText: "0",
        formatNumber: true,
        enterClick: () {
          onlinePaymentAddProcess();
        },
        numberController: cashController,
        fullWidth: constraints.maxWidth,
        gridHeight: 90,
      ),
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
                      "Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: screenSize.height * 0.37,
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
                      Text(tr(LocaleKeys.takeVoucher)),
                    ],
                  ),

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
    EditSaleCartCubit cartCubit,
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
            child: Text(""),
            onPressed: () async {
              grandTotal = 0;
              discountAmount = 0;
              taxAmount = 0;
              if (customerTakevoucher) {
                grandTotal = widget.subTotal + widget.tax;
                taxAmount = widget.tax;
                discountAmount = 0;
              } else {
                grandTotal = widget.subTotal;
                discountAmount = widget.tax;
                taxAmount = 0;
              }

              updateSaleData(
                discountAmount: discountAmount,
                taxAmount: taxAmount,
                ahtoneLevel: cartCubit.state.athoneLevel,
                spicyLevel: cartCubit.state.spicyLevel,
                cartItems: cartItems,
              );
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
            margin: EdgeInsets.only(bottom: 5, top: 5),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: ColorConstants.greyColor,
            ),
          ),

          ///Online Pay
          SizedBox(height: 5),
          _amountRowWidget(
            amount: paidOnline,
            title: "Online Pay",
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
            title,
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
    // paidOnline = grandTotal - cashAmount;
    cashController.text = "0";

    calculateRefund();
  }

  ///Online Pay adding process
  void onlinePaymentAddProcess() {
    paidOnline =
        cashController.text.isNotEmpty ? int.parse(cashController.text) : 0;
    cashController.text = "0";
    //paidOnline = grandTotal - cashAmount;

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

  void updateSaleData({
    required int taxAmount,
    required int discountAmount,
    required List<CartItem> cartItems,
    required AhtoneLevelModel? ahtoneLevel,
    required SpicyLevelModel? spicyLevel,
  }) async {
    ///check conditions that if the curret sale process items is from pending orders or not
    List<Product> productList = context
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
        .toList();

    SaleModel saleModel = SaleModel(
      octopusCount: widget.octopusCount,
      prawnCount: widget.prawnCount,
      remark: widget.remark,
      ahtoneLevelId: widget.athoneLevel == 000 ? null : widget.athoneLevel,
      spicyLevelId: widget.spicyLevel == 000 ? null : widget.spicyLevel,
      dineInOrParcel: widget.dineInOrParcel,
      grandTotal: grandTotal,
      menuId: widget.menuId,
      orderNo: widget.orderNo,
      paidCash: cashAmount,
      products: productList,
      tableNumber: widget.tableNumber,
      refund: refundAmount,
      subTotal: widget.subTotal,
      tax: taxAmount,
      discount: discountAmount,
      paidOnline: paidOnline,
    );
    await context
        .read<SaleProcessCubit>()
        .updateSale(saleRequest: saleModel)
        .then(
      (value) {
        if (value) {
          if(!mounted) return;
          redirectTo(
            context: context,
            form: SaleSuccessPage(
              customerTakevoucher: customerTakevoucher,
              ahtoneLevel: ahtoneLevel,
              menuTitle: widget.menu,
              spicyLevel: spicyLevel,
              taxAmount: taxAmount,
              saleData: saleModel,
              cartItems: cartItems,
              paymentType: "Cash / Online Pay",
              dateTime: widget.date,
              isEditSale: true,
            ),
            replacement: true,
          );
        }
      },
    );
  }
}
