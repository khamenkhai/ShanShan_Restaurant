import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/models/response_models/category_model.dart';
import 'package:shan_shan/models/response_models/product_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';

class ProductCRUDDialog extends StatefulWidget {
  final Size screenSize;
  final ProductModel? product;

  const ProductCRUDDialog({
    super.key,
    required this.screenSize,
    this.product,
  });

  @override
  State<ProductCRUDDialog> createState() => _ProductCRUDDialogState();
}

class _ProductCRUDDialogState extends State<ProductCRUDDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");

  bool _isGram = false;
  bool _isDefault = false;
  int? _selectedCategoryId;
  String _category = '';

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _initializeFormData() {
    if (widget.product != null) {
      _productNameController.text = widget.product!.name.toString();
      _productPriceController.text = widget.product!.price.toString();
      _selectedCategoryId = widget.product!.categoryId;
      _category = widget.product!.category ?? "";
      _isGram = widget.product!.isGram ?? false;
      _isDefault = widget.product!.isDefault ?? false;
      _quantityController.text = widget.product!.qty.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: widget.screenSize.width / 3.8,
          child: Form(
            key: _formKey,
            child: _buildFormContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProductNameField(),
        const SizedBox(height: 15),
        _buildPriceField(),
        const SizedBox(height: 15),
        _buildCategoryDropdown(),
        const SizedBox(height: 15),
        _buildGramCheckbox(),
        const SizedBox(height: 15),
        _buildDefaultCheckbox(),
        const SizedBox(height: 20),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildProductNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr(LocaleKeys.productName), style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextFormField(
          controller: _productNameController,
          validator: (value) =>
              value?.isEmpty ?? true ? tr(LocaleKeys.productNameValidation) : null,
          decoration: customTextDecoration2(
            labelText: tr(LocaleKeys.enterProductName),
            primaryColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr(LocaleKeys.price), style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        TextFormField(
          controller: _productPriceController,
          validator: (value) =>
              value?.isEmpty ?? true ? tr(LocaleKeys.priceValidation) : null,
          decoration: customTextDecoration2(
              labelText: tr(LocaleKeys.enterPrice),
              primaryColor: Theme.of(context).primaryColor),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr(LocaleKeys.category), style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoadedState) {
              return DropdownButtonFormField<int>(
                decoration: _dropdownDecoration(),
                value: _selectedCategoryId,
                items: _buildCategoryItems(state.categoryList),
                onChanged: (newValue) => setState(() {
                  _selectedCategoryId = newValue;
                }),
                validator: (value) => _selectedCategoryId == null
                    ? 'Please select category'
                    : null,
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      hintText: _category,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      errorBorder: _inputBorder(error: true),
      focusedBorder: _inputBorder(focused: true),
    );
  }

  OutlineInputBorder _inputBorder({bool error = false, bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: SizeConst.kBorderRadius,
      borderSide: BorderSide(
        width: focused ? 1 : 0.5,
        color: error
            ? Colors.red
            : focused
                ? Theme.of(context).primaryColor
                : AppColors.greyColor,
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildCategoryItems(
      List<CategoryModel> categories) {
    return categories
        .map((e) => DropdownMenuItem(
              value: e.id,
              child: Text(e.name ?? ""),
            ))
        .toList();
  }

  Widget _buildGramCheckbox() {
    return _CustomCheckbox(
      value: _isGram,
      label: tr(LocaleKeys.isGram),
      onChanged: (value) => setState(() => _isGram = value),
    );
  }

  Widget _buildDefaultCheckbox() {
    return _CustomCheckbox(
      value: _isDefault,
      label: tr(LocaleKeys.requiredInMenu),
      onChanged: (value) => setState(() => _isDefault = value),
    );
  }

  Widget _buildActionButtons() {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductAddedState) {
          Navigator.pop(context);
        } else if (state is ProductUpdatedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is ProductsAddingState || state is ProductsUpdatingState) {
          return LoadingWidget();
        }

        return CancelAndConfirmDialogButton(
          onConfirm: () {
            _handleFormSubmission();
          },
        );
      },
    );
  }

  void _handleFormSubmission() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.product != null) {
      _editProduct();
    } else {
      _createNewProduct();
    }
  }

  void _createNewProduct() async {
    await context.read<ProductsCubit>().addNewProduct(
          requestBody: ProductModel(
            categoryId: _selectedCategoryId ?? 0,
            isGram: _isGram,
            name: _productNameController.text,
            price: int.parse(_productPriceController.text),
            qty: 1,
            isDefault: _isDefault,
          ).toJson(),
        );
  }

  void _editProduct() async {
    await context.read<ProductsCubit>().updateProduct(
          requestBody: ProductModel(
            categoryId: _selectedCategoryId ?? 0,
            isGram: _isGram,
            name: _productNameController.text,
            isDefault: _isDefault,
            price: int.parse(_productPriceController.text),
            qty: int.parse(_quantityController.text),
          ).toJson(),
          id: widget.product!.id.toString(),
        );
  }
}

class _CustomCheckbox extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const _CustomCheckbox({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_box : Icons.check_box_outline_blank,
            color: value ? Theme.of(context).primaryColor : Colors.grey,
          ),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
