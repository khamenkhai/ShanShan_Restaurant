import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/view/payment/payment.dart';
import 'package:shan_shan/view/payment/multi_payment_page.dart';

class EditSaleCheckoutDialog extends StatefulWidget {
  final bool paidOnline;
  final bool paidCash;
  final double? width;

  const EditSaleCheckoutDialog({
    super.key,
    required this.paidOnline,
    required this.paidCash,
    this.width,
  });

  @override
  State<EditSaleCheckoutDialog> createState() => _EditSaleCheckoutDialogState();
}

class _EditSaleCheckoutDialogState extends State<EditSaleCheckoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tableController = TextEditingController();
  final _remarkController = TextEditingController();

  bool _isParcel = false;
  int _prawnCount = 0;
  int _octopusCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeFromCartState();
  }

  @override
  void dispose() {
    _tableController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _initializeFromCartState() {
    final cartState = context.read<OrderEditCubit>().state;
    setState(() {
      _prawnCount = cartState.prawnCount;
      _octopusCount = cartState.octopusCount;
      _remarkController.text = cartState.remark;
      _isParcel = cartState.dineInOrParcel == 0;
      _tableController.text =
          cartState.tableNumber == 0 ? "" : cartState.tableNumber.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      backgroundColor: theme.cardColor,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.width ?? screenWidth / 2.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 24),
                _buildTableNumberField(),
                const SizedBox(height: 20),
                _buildOrderTypeSection(),
                const SizedBox(height: 20),
                _buildRemarkField(),
                const SizedBox(height: 16),
                _buildCounterRow(
                  label: LocaleKeys.octopus.tr(),
                  count: _octopusCount,
                  onChanged: (count) => setState(() => _octopusCount = count),
                ),
                const SizedBox(height: 12),
                _buildCounterRow(
                  label: LocaleKeys.prawn.tr(),
                  count: _prawnCount,
                  onChanged: (count) => setState(() => _prawnCount = count),
                ),
                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.orderTitle.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "(${_paidOptions()})",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Divider(color: theme.dividerColor, thickness: 0.5),
      ],
    );
  }

  Widget _buildTableNumberField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _tableController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: LocaleKeys.tableNumber.tr(),
          hintText: LocaleKeys.tableNumberHint.tr(),
          border: OutlineInputBorder(
            borderRadius: SizeConst.kBorderRadius,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty || value == "0") {
            return LocaleKeys.tableNumberRequired.tr();
          }
          return null;
        },
      ),
    );
  }

  Widget _buildOrderTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.dineInOrParcel.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildOrderTypeToggle(
              value: false,
              label: LocaleKeys.dineIn.tr(),
              icon: "🍴",
            ),
            const SizedBox(width: 16),
            _buildOrderTypeToggle(
                value: true, label: LocaleKeys.parcel.tr(), icon: "📦"),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderTypeToggle({
    required bool value,
    required String label,
    required String icon,
  }) {
    final isSelected = _isParcel == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _isParcel = value),
        borderRadius: SizeConst.kBorderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: SizeConst.kBorderRadius,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: context.subTitle(
                  color:
                      isSelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? Theme.of(context).primaryColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemarkField() {
    return TextField(
      controller: _remarkController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: LocaleKeys.remarkHint.tr(),
        border: OutlineInputBorder(
          borderRadius: SizeConst.kBorderRadius,
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildCounterRow({
    required String label,
    required int count,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: count == 0 ? Colors.grey : Colors.red,
          onPressed: count == 0 ? null : () => onChanged(count - 1),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: Theme.of(context).primaryColor,
          onPressed: () => onChanged(count + 1),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomOutlineButton(
          child: Text(LocaleKeys.cancelOrder.tr()),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 12),
        CustomElevatedButton(
          onPressed: _handleConfirmOrder,
          child: Text(LocaleKeys.confirmOrder.tr()),
        ),
      ],
    );
  }

  void _handleConfirmOrder() {
    if (!_formKey.currentState!.validate()) return;

    final orderCubit = context.read<OrderEditCubit>();
    orderCubit.addData(
      dineInOrParcel: _isParcel ? 0 : 1,
      octopusCount: _octopusCount,
      prawnCount: _prawnCount,
      tableNumber: int.tryParse(_tableController.text) ?? 0,
      remark: _remarkController.text,
    );

    final paymentScreen = _getPaymentScreen();
    if (paymentScreen != null) {
      NavigationHelper.pushPage(context, paymentScreen);
    }
  }

  Widget? _getPaymentScreen() {
    if (widget.paidCash && widget.paidOnline) {
      return const MultiPaymentPage();
    } else if (widget.paidCash || widget.paidOnline) {
      return const PaymentScreen(isEditState: true);
    } else{
      return null; // No payment required
    }
  }

  String _paidOptions() {
    if (widget.paidCash && widget.paidOnline) {
      return "Multiple Payment ";
    } else if (widget.paidCash) {
      return LocaleKeys.cash.tr();
    } else if (widget.paidOnline) {
      return LocaleKeys.onlinePay.tr();
    } else {
      return "";
    }
  }
}
