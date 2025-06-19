import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/product_model.dart';
import 'package:shan_shan/core/component/custom_dialog.dart';

class ProductWeightOrDetailControl extends StatefulWidget {
  final ProductModel product;
  final bool isEditState;

  const ProductWeightOrDetailControl({
    super.key,
    required this.product,
    required this.isEditState,
  });

  @override
  State<ProductWeightOrDetailControl> createState() =>
      _ProductWeightOrDetailControlState();
}

class _ProductWeightOrDetailControlState
    extends State<ProductWeightOrDetailControl> {
  late final TextEditingController _gramController;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _gramController = TextEditingController(text: "100");
  }

  @override
  void dispose() {
    _gramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: widget.product.isGram ?? false
          ? _buildGramControl(context)
          : _buildQuantityControl(),
    );
  }

  Widget _buildGramControl(BuildContext context) {
    return _buildControlLayout(
      context,
      title: widget.product.name ?? '',
      controlWidget: _buildGramAdjuster(),
      onConfirm: () => _handleGramAddToCart(context),
    );
  }

  Widget _buildQuantityControl() {
    return _buildControlLayout(
      context,
      title: widget.product.name ?? '',
      controlWidget: _buildQuantityAdjuster(),
      onConfirm: _handleQuantityAddToCart,
    );
  }

  Widget _buildControlLayout(
    BuildContext context, {
    required String title,
    required Widget controlWidget,
    required VoidCallback onConfirm,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 24),
          Center(child: controlWidget),
          const SizedBox(height: 24),
          _buildActionButtons(context, onConfirm),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, VoidCallback onConfirm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomOutlineButton(
          elevation: 0,
          child: Text(LocaleKeys.cancel.tr()),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 12),
        CustomElevatedButton(
          child: Text(LocaleKeys.confirm.tr()),
          onPressed: onConfirm,
        ),
      ],
    );
  }

  Widget _buildGramAdjuster() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAdjustButton(
          icon: Icons.remove,
          onTap: _decrementGram,
          isDecrement: true,
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _gramController,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: 'g',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildAdjustButton(
          icon: Icons.add,
          onTap: _incrementGram,
          isDecrement: false,
        ),
      ],
    );
  }

  Widget _buildQuantityAdjuster() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAdjustButton(
            icon: Icons.remove,
            onTap: _decrementQuantity,
            isDecrement: true,
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 40,
            child: Text(
              '$_quantity',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),
          _buildAdjustButton(
            icon: Icons.add,
            onTap: _incrementQuantity,
            isDecrement: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDecrement,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: isDecrement ? Colors.grey : Theme.of(context).primaryColor,
      iconSize: 24,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _incrementGram() {
    setState(() {
      final value = num.tryParse(_gramController.text) ?? 100;
      _gramController.text = (value + 100).toString();
    });
  }

  void _decrementGram() {
    setState(() {
      final value = num.tryParse(_gramController.text) ?? 100;
      _gramController.text = value > 100 ? (value - 100).toString() : '100';
    });
  }

  void _incrementQuantity() {
    setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _handleGramAddToCart(BuildContext context) {
    final gramValue = num.tryParse(_gramController.text) ?? 100;
    final cartItem = CartItem(
      isGram: widget.product.isGram ?? false,
      name: widget.product.name?.replaceAll(',', '') ?? '',
      id: widget.product.id!,
      qty: gramValue.toInt(),
      price: widget.product.price ?? 0,
      totalPrice: widget.product.price ?? 0,
    );

    if (widget.isEditState) {
      context.read<EditSaleCartCubit>().addToCartByGram(
            item: cartItem,
            gram: gramValue.toInt(),
          );
    } else {
      context.read<CartCubit>().addToCartByGram(
            item: cartItem,
            gram: gramValue.toInt(),
          );
    }
    Navigator.pop(context);
  }

  void _handleQuantityAddToCart() {
    final cartItem = CartItem(
      isGram: widget.product.isGram ?? false,
      name: widget.product.name?.replaceAll(',', '') ?? '',
      id: widget.product.id!,
      qty: 1,
      price: widget.product.price ?? 0,
      totalPrice: widget.product.price ?? 0,
    );

    if (widget.isEditState) {
      context.read<EditSaleCartCubit>().addToCartByQuantity(
            item: cartItem,
            quantity: _quantity,
          );
    } else {
      context.read<CartCubit>().addToCartByQuantity(
            item: cartItem,
            quantity: _quantity,
          );
    }
    Navigator.pop(context);
  }
}