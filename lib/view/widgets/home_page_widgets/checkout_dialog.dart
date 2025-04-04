import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/view/payment/cash.dart';
import 'package:shan_shan/view/payment/online_payment.dart';

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
  final _tableCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();

  bool _isParcel = false;
  int _prawnCount = 0;
  int _octopusCount = 0;

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartCubit>().state;
    _prawnCount = cart.prawnCount;
    _octopusCount = cart.octopusCount;
    _remarkCtrl.text = cart.remark;
    _isParcel = cart.dineInOrParcel == 0;
    _tableCtrl.text = cart.tableNumber.toString();
  }

  @override
  void dispose() {
    _tableCtrl.dispose();
    _remarkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          width: widget.width ?? screenWidth / 3.8,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header("မှာယူမှု"),
              const SizedBox(height: 15),
              _formField("စားပွဲနံပါတ်", _tableCtrl, validator: (val) {
                return (val == null || val.isEmpty)
                    ? "စားပွဲနံပါတ် လိုအပ်ပါသည်။!"
                    : null;
              }),
              const SizedBox(height: 15),
              _orderTypeSection(),
              const SizedBox(height: 25),
              _formField("မှတ်ချက်", _remarkCtrl, multiline: true),
              const SizedBox(height: 5),
              _CounterRow(
                  label: "ရေဘဝဲ",
                  count: _octopusCount,
                  onIncrement: () => setState(() => _octopusCount++),
                  onDecrement: () => setState(() => _octopusCount =
                      (_octopusCount - 1).clamp(0, _octopusCount))),
              _CounterRow(
                  label: "ပုဇွန်",
                  count: _prawnCount,
                  onIncrement: () => setState(() => _prawnCount++),
                  onDecrement: () => setState(() =>
                      _prawnCount = (_prawnCount - 1).clamp(0, _prawnCount))),
              const SizedBox(height: 20),
              _actionButtons(cartCubit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: ColorConstants.primaryColor,
        ),
      );

  Widget _formField(String label, TextEditingController controller,
      {FormFieldValidator<String>? validator, bool multiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        if (validator != null)
          Form(
            key: _formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              validator: validator,
              decoration: const InputDecoration(
                  hintText: "စားပွဲနံပါတ်ရေးရန်",
                  hintStyle: TextStyle(fontSize: 13)),
            ),
          )
        else
          TextField(
            controller: controller,
            maxLines: multiline ? 3 : 1,
            decoration: const InputDecoration(
                hintText: "မှတ်ချက်ရေးရန်", hintStyle: TextStyle(fontSize: 13)),
          ),
      ],
    );
  }

  Widget _orderTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ထိုင်စား or ပါဆယ်",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        ...[
          _orderTypeOption(false, "ထိုင်စား"),
          _orderTypeOption(true, "ပါဆယ်"),
        ]
      ],
    );
  }

  Widget _orderTypeOption(bool value, String label) {
    final selected = _isParcel == value;
    return InkWell(
      onTap: () => setState(() => _isParcel = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons(CartCubit cartCubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomOutlineButton(
          child: const Text("ပယ်ဖျက်ရန်"),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        CustomElevatedButton(
          child: const Text("အတည်ပြုရန်"),
          onPressed: () => _confirmOrder(cartCubit),
        ),
      ],
    );
  }

  void _confirmOrder(CartCubit cartCubit) {
    if (!_formKey.currentState!.validate()) return;

    final remark = _remarkCtrl.text;
    cartCubit.addData(
      dineInOrParcel: _isParcel ? 0 : 1,
      octopusCount: _octopusCount,
      prawnCount: _prawnCount,
      tableNumber: int.tryParse(_tableCtrl.text) ?? 0,
    );

    final screen = _getPaymentScreen(cartCubit, remark);
    if (screen != null) NavigationHelper.pushPage(context, screen);
  }

  Widget? _getPaymentScreen(CartCubit cartCubit, String remark) {

    if (widget.paidCash && widget.paidOnline) {
      // return KpayAndCashScreen();
    } else if (widget.paidCash) {
      return CashScreen();
    } else if (widget.paidOnline) {
      return OnlinePaymentScreen();
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
        Text(label, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        IconButton(
            onPressed: onDecrement, icon: const Icon(Icons.remove_circle)),
        Text("$count", style: const TextStyle(fontSize: 16)),
        IconButton(onPressed: onIncrement, icon: const Icon(Icons.add_circle)),
      ],
    );
  }
}
