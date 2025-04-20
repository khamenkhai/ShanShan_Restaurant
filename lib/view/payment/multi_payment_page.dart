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
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/sale_success/sale_success_page.dart';
import 'package:shan_shan/view/home/widget/cart_item_widget.dart';
import 'package:shan_shan/view/widgets/date_action_widget.dart';
import 'package:shan_shan/view/widgets/number_buttons.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MultiPaymentPage extends StatefulWidget {
  const MultiPaymentPage({super.key});

  @override
  State<MultiPaymentPage> createState() => _MultiPaymentPageState();
}

class _MultiPaymentPageState extends State<MultiPaymentPage> {
  final TextEditingController _cashController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();

  int _cashAmount = 0;
  int _paidOnline = 0;
  int _refundAmount = 0;
  int _subTotal = 0;
  int _taxAmount = 0;
  int _grandTotal = 0;
  int _paymentIndex = 0;
  bool _customerTakeVoucher = true;
 

  @override
  void dispose() {
    _cashController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _calculateAmounts() {
    final cartCubit = context.read<CartCubit>();
    _subTotal = cartCubit.getTotalAmount();
    _taxAmount = _customerTakeVoucher ? get5percentage(_subTotal) : 0;
    _grandTotal = _subTotal + _taxAmount;

    if (_cashAmount > _grandTotal) {
      _refundAmount = _cashAmount - _grandTotal;
    } else {
      _refundAmount = 0;
    }
  }

  void _calculateRefund() {
    final grandTotal = _customerTakeVoucher 
        ? _subTotal + _taxAmount 
        : _subTotal;

    if ((_paidOnline + _cashAmount) > grandTotal) {
      _refundAmount = (_paidOnline + _cashAmount) - grandTotal;
    } else {
      _refundAmount = 0;
    }
    setState(() {});
  }

  bool _isCheckoutEnabled() {
    return (_cashAmount + _paidOnline) >= _grandTotal;
  }

  void _handleCashPayment() {
    _cashAmount = _cashController.text.isNotEmpty 
        ? int.parse(_cashController.text) 
        : 0;
    _cashController.text = "0";
    _calculateRefund();
  }

  void _handleKpayPayment() {
    _paidOnline = _cashController.text.isNotEmpty 
        ? int.parse(_cashController.text) 
        : 0;
    _cashController.text = "0";
    _calculateRefund();
  }

  Future<void> _processCheckout(List<CartItem> cartItems, CartCubit cartCubit) async {
    final grandTotal = _customerTakeVoucher 
        ? _subTotal + _taxAmount 
        : _subTotal;
    final discountAmount = _customerTakeVoucher ? 0 : _taxAmount;
    final taxAmount = _customerTakeVoucher ? _taxAmount : 0;

    final dateTime = DateTime.now();
    final saleModel = SaleModel(
      octopusCount: cartCubit.state.octopusCount,
      prawnCount: cartCubit.state.prawnCount,
      remark: cartCubit.state.remark,
      ahtoneLevelId: cartCubit.state.athoneLevel?.id ?? 000,
      spicyLevelId: cartCubit.state.spicyLevel?.id ?? 000,
      dineInOrParcel: cartCubit.state.dineInOrParcel,
      grandTotal: grandTotal,
      menuId: cartCubit.state.menu?.id ?? 0,
      orderNo: "SS-${generateRandomId(6)}",
      paidCash: _cashAmount,
      products: cartItems.map((e) => Product(
        productId: e.id,
        qty: e.qty,
        price: e.price,
        totalPrice: e.totalPrice,
      )).toList(),
      tableNumber: cartCubit.state.tableNumber,
      refund: _refundAmount,
      subTotal: _subTotal,
      tax: taxAmount,
      discount: discountAmount,
      paidOnline: _paidOnline,
    );

    final success = await context.read<SaleProcessCubit>().makeSale(
      saleRequest: saleModel,
    );

    if (success && mounted) {
      redirectTo(
        context: context,
        form: SaleSuccessPage(
          customerTakevoucher: _customerTakeVoucher,
          ahtoneLevel: cartCubit.state.athoneLevel,
          menuTitle: cartCubit.state.menu?.name ?? "",
          spicyLevel: cartCubit.state.spicyLevel,
          taxAmount: taxAmount,
          saleData: saleModel,
          cartItems: cartItems,
          paymentType: "Cash / Online",
          dateTime: DateFormat('dd, MMMM yyyy hh:mm a').format(dateTime),
          isEditSale: false,
        ),
        replacement: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cartCubit = context.read<CartCubit>();

    _calculateAmounts();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 160,
        leading: AppBarLeading(onTap: () => Navigator.pop(context)),
        actions: const [
          DateActionWidget(),
          SizedBox(width: 25),
        ],
        title: const Text("Cash & Kpay"),
      ),
      body: InternetCheckWidget(
        child: _buildPaymentForm(screenSize, cartCubit),
        onRefresh: () {},
      ),
    );
  }

  Widget _buildPaymentForm(Size screenSize, CartCubit cartCubit) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSaleSummary(screenSize, cartCubit),
          _buildPaymentTabs(screenSize),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildSaleSummary(Size screenSize, CartCubit cartCubit) {
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
                    margin: const EdgeInsets.only(left: 10),
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
                    height: screenSize.height * 0.38,
                    child: SingleChildScrollView(
                      child: Column(
                        children: state.items.map((e) => CartItemWidget(
                          ontapDisable: true,
                          cartItem: e,
                          onDelete: () {},
                          onEdit: () {},
                        )).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentSummary(cartCubit),
                  Row(
                    children: [
                      Checkbox(
                        value: _customerTakeVoucher,
                        activeColor: ColorConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _customerTakeVoucher = value!;
                            _calculateRefund();
                          });
                        },
                      ),
                      const Text("ဘောက်ချာယူမည်"),
                    ],
                  ),
                  const SizedBox(height: 5),
                  _buildCheckoutButton(state.items, cartCubit),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTabs(Size screenSize) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        right: 15,
        left: 15,
        bottom: 20,
      ),
      margin: EdgeInsets.only(
        bottom: 15, 
        right: SizeConst.kHorizontalPadding
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      width: screenSize.width * 0.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "ငွေပေးချေမှုနည်းလမ်းများ :",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ToggleSwitch(
                    minWidth: 90.0,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: _paymentIndex,
                    totalSwitches: 2,
                    labels: ['ငွေသား', 'Kpay'],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        _paymentIndex = index!;
                      });
                    },
                  ),
                ],
              ),
              Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.only(right: 15, top: 5),
                child: CustomElevatedButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 7),
                      Text("အော်ဒါပြင်ရန်"),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              _paymentIndex == 0 
                  ? _buildCashPaymentButtons(constraints) 
                  : _buildKpayPaymentButtons(constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCashPaymentButtons(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      child: NumberButtons(
        defaultText: "0",
        formatNumber: true,
        enterClick: _handleCashPayment,
        numberController: _cashController,
        fullWidth: constraints.maxWidth,
        gridHeight: 90,
      ),
    );
  }

  Widget _buildKpayPaymentButtons(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      child: NumberButtons(
        defaultText: "0",
        formatNumber: true,
        enterClick: _handleKpayPayment,
        numberController: _cashController,
        fullWidth: constraints.maxWidth,
        gridHeight: 90,
      ),
    );
  }

  Widget _buildPaymentSummary(CartCubit cartCubit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            child: const Divider(
              height: 1,
              thickness: 0.5,
              color: ColorConstants.greyColor,
            ),
          ),
          const SizedBox(height: 5),
          _buildAmountRow("Kpay", _paidOnline),
          const SizedBox(height: 5),
          _buildAmountRow("ငွေသား", _cashAmount),
          const SizedBox(height: 5),
          _buildAmountRow("Refund", _refundAmount, isChange: true),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: const Divider(height: 0.5),
          ),
          _buildAmountRow("GrandTotal", _grandTotal),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String title, num amount, {bool isChange = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${formatNumber(amount)} MMK",
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

  Widget _buildCheckoutButton(List<CartItem> cartItems, CartCubit cartCubit) {
    return BlocBuilder<SaleProcessCubit, SaleProcessState>(
      builder: (context, state) {
        if (state is SaleProcessLoadingState) {
          return const LoadingWidget();
        }
        return CustomElevatedButton(
          isEnabled: _isCheckoutEnabled(),
          width: double.infinity,
          elevation: 0,
          height: 70,
          child: const Text("ငွေရှင်းရန်လုပ်ဆောင်ပါ"),
          onPressed: () => _processCheckout(cartItems, cartCubit),
        );
      },
    );
  }
}