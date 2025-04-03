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

class KpayScreen extends StatefulWidget {
  const KpayScreen({
    super.key,
    required this.subTotal,
    required this.tax,
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
  final int athoneLevel;
  final int spicyLevel;
  final int dineInOrParcel;
  final int menu_id;
  final int table_number;
  final int prawnCount;
  final int octopusCount;
  final String remark;
  final String menu;

  @override
  State<KpayScreen> createState() => _KpayScreenState();
}

class _KpayScreenState extends State<KpayScreen> {
  TextEditingController cashController = TextEditingController();

  int kpayAmount = 0;
  int grandTotal = 0;
  int taxAmount = 0;
  int discountAmount = 0;

  bool customerTakevoucher = true;

  @override
  void initState() {
    super.initState();
  }

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
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Kpay ဖြင့်ပေးချေရန်"),
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
          _paymentMethodAndEditButton(screenSize),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  ///payment method and edit button widget
  Container _paymentMethodAndEditButton(Size screenSize) {
    return Container(
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
      height: 180,
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
                    "Kpay",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                child: CustomElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                  _costWidget(cartCubit: cartCubit),

                  Spacer(),
                  Row(
                    children: [
                      Checkbox(
                        value: customerTakevoucher,
                        activeColor: ColorConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            customerTakevoucher = value!;
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
    required CartCubit cartCubit,
  }) {
    return BlocBuilder<SaleProcessCubit, SaleProcessState>(
      builder: (context, state) {
        if (state is SaleProcessLoadingState) {
          return LoadingWidget();
        } else {
          return CustomElevatedButton(
            isEnabled: true,
            width: double.infinity,
            elevation: 0,
            height: 70,
            child: Text("ငွေရှင်းရန်လုပ်ဆောင်ပါ"),
            onPressed: () async {
              ///*****///

              if (customerTakevoucher) {
                grandTotal = widget.subTotal + widget.tax;
                taxAmount = widget.tax;
                discountAmount = 0;
              } else {
                grandTotal = widget.subTotal;
                taxAmount = 0;
                discountAmount = widget.tax;
              }

              kpayAmount = grandTotal;

              await checkout(cartCubit: cartCubit, cartItems: cartItems);
            },
          );
        }
      },
    );
  }

  ///total cost widget
  Widget _costWidget({required CartCubit cartCubit}) {
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
          _amountRowWidget(amount: grandTotal, title: "GrandTotal"),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  ///total amount widget(row)
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

  ///checkout process
  checkout({
    required CartCubit cartCubit,
    required List<CartItem> cartItems,
  }) async {
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
      paid_cash: 0,
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
      sub_total: widget.subTotal,
      tax: taxAmount,
      discount: discountAmount,
      paid_online: kpayAmount,
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
              menu: widget.menu,
              customerTakevoucher: customerTakevoucher,
              octopusCount: widget.octopusCount,
              prawnCount: widget.prawnCount,
              taxAmount: taxAmount,
              saleData: saleModel,
              cartItems: cartItems,
              remark: widget.remark,
              paymentType: "Kpay",
              dineInOrParcel: widget.dineInOrParcel,
              dateTime: DateFormat('dd, MMMM yyyy hh:mm a').format(dateTime),
              ahtoneLevel: cartCubit.state.athoneLevel,
              spicyLevel: cartCubit.state.spicyLevel,
              isEditSale: false,
            ),
            replacement: true,
          );
        } else {
          showCustomSnackbar(context: context, message: "Checkout failed!");
        }
      },
    );
  }
}
