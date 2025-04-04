import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/view/pages/payment/bank.dart';
import 'package:shan_shan/view/pages/payment/bank_and_cash.dart';
import 'package:shan_shan/view/pages/payment/cash.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

class CheckoutDialog extends StatefulWidget {
  final bool paidOnline;
  final bool paidCash;
  final double? width;

  const CheckoutDialog({
    super.key,
    required this.paidOnline,
    required this.paidCash,
    this.width,
  });

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tableController = TextEditingController();
  final _remarkController = TextEditingController();

  bool _isParcel = false;
  int _prawnCount = 0;
  int _octopusCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  void dispose() {
    _tableController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _initializeFormData() {
    final cartState = context.read<CartCubit>().state;
    _prawnCount = cartState.prawnCount;
    _octopusCount = cartState.octopusCount;
    _remarkController.text = cartState.remark;
    _isParcel = cartState.dineInOrParcel == 0;
    _tableController.text = cartState.tableNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cartCubit = context.read<CartCubit>();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: widget.width ?? screenSize.width / 3.8,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildTableNumberField(),
              const SizedBox(height: 15),
              _buildOrderTypeSelection(),
              const SizedBox(height: 25),
              _buildRemarkField(),
              const SizedBox(height: 5),
              _buildOctopusCounter(),
              _buildPrawnCounter(),
              const SizedBox(height: 20),
              _buildActionButtons(cartCubit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      "မှာယူမှု",
      style: TextStyle(
        fontSize: 19,
        color: ColorConstants.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTableNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "စားပွဲနံပါတ်",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _tableController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "စားပွဲနံပါတ် လိုအပ်ပါသည်။!";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "စားပွဲနံပါတ်ရေးရန်",
              hintStyle: TextStyle(fontSize: 13),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ထိုင်စား or ပါဆယ်",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        _buildRadioOption(
          value: false,
          label: "ထိုင်စား",
          isSelected: !_isParcel,
        ),
        const SizedBox(height: 15),
        _buildRadioOption(
          value: true,
          label: "ပါဆယ်",
          isSelected: _isParcel,
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required bool value,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => setState(() => _isParcel = value),
      child: Row(
        children: [
          Icon(
            isSelected 
              ? Icons.radio_button_checked 
              : Icons.radio_button_off,
          ),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildRemarkField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "မှတ်ချက်",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          controller: _remarkController,
          decoration: const InputDecoration(
            hintText: "မှတ်ချက်ရေးရန်",
            hintStyle: TextStyle(fontSize: 13),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ],
    );
  }

  Widget _buildOctopusCounter() {
    return _CounterRow(
      label: "ရေဘဝဲ",
      count: _octopusCount,
      onDecrement: () {
        if (_octopusCount > 0) {
          setState(() => _octopusCount--);
        }
      },
      onIncrement: () => setState(() => _octopusCount++),
    );
  }

  Widget _buildPrawnCounter() {
    return _CounterRow(
      label: "ပုဇွန်",
      count: _prawnCount,
      onDecrement: () {
        if (_prawnCount > 0) {
          setState(() => _prawnCount--);
        }
      },
      onIncrement: () => setState(() => _prawnCount++),
    );
  }

  Widget _buildActionButtons(CartCubit cartCubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        customizableOTButton(
          elevation: 0,
          child: const Text("ပယ်ဖျက်ရန်"),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        CustomElevatedButton(
          child: const Text("အတည်ပြုရန်"),
          onPressed: () => _handleOrderConfirmation(cartCubit),
        ),
      ],
    );
  }

  void _handleOrderConfirmation(CartCubit cartCubit) {
    final remark = _remarkController.text;
    
    cartCubit.addAdditionalData(
      remark: remark,
      dineInOrParcel: _isParcel ? 0 : 1,
      octopusCount: _octopusCount,
      prawnCount: _prawnCount,
      tableNumber: _tableController.text.isEmpty 
          ? 0 
          : int.parse(_tableController.text),
    );

    if (!_formKey.currentState!.validate()) return;

    final paymentScreen = _getPaymentScreen(cartCubit, remark);
    if (paymentScreen != null) {
      redirectTo(context: context, form: paymentScreen);
    }
  }

  Widget? _getPaymentScreen(CartCubit cartCubit, String remark) {
    final menu = cartCubit.state.menu!;
    final total = cartCubit.getTotalAmount();
    final tax = get5percentage(total);

    if (widget.paidCash && !widget.paidOnline) {
      return CashScreen(
        octopusCount: _octopusCount,
        prawnCount: _prawnCount,
        remark: remark,
        menu: menu.name.toString(),
        athoneLevel: cartCubit.state.athoneLevel?.id ?? 0,
        spicyLevel: cartCubit.state.spicyLevel?.id ?? 0,
        menuId: menu.id,
        tableNo: int.parse(_tableController.text),
        dineInOrParcel: _isParcel ? 0 : 1,
        subTotal: total,
        tax: tax,
        paidCash: widget.paidCash,
      );
    } else if (!widget.paidCash && widget.paidOnline) {
      return KpayScreen(
        menu: menu.name.toString(),
        remark: remark,
        athoneLevel: cartCubit.state.athoneLevel?.id ?? 0,
        spicyLevel: cartCubit.state.spicyLevel?.id ?? 0,
        menuId: menu.id ,
        tableNumber: int.parse(_tableController.text),
        dineInOrParcel: _isParcel ? 0 : 1,
        subTotal: total,
        tax: tax,
        prawnCount: _prawnCount,
        octopusCount: _octopusCount,
      );
    } else if (widget.paidCash && widget.paidOnline) {
      return KpayAndCashScreen(
        menu: menu.name.toString(),
        remark: remark,
        athoneLevel: cartCubit.state.athoneLevel?.id ?? 0,
        spicyLevel: cartCubit.state.spicyLevel?.id ?? 0,
        menuId: menu.id ,
        tableNo: int.parse(_tableController.text),
        dineInOrParcel: _isParcel ? 0 : 1,
        subTotal: total,
        tax: tax,
        prawnCount: _prawnCount,
        octopusCount: _octopusCount,
      );
    }
    return null;
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CounterRow({
    required this.label,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle),
        ),
        SizedBox(
          width: 20,
          child: Text(
            "$count",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle),
        ),
      ],
    );
  }
}