import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/model/response_models/product_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';

////products crud dialob box
class ProductCRUDDialog extends StatefulWidget {
  const ProductCRUDDialog({
    super.key,
    required this.screenSize,
    this.product,
  });

  final Size screenSize;

  final ProductModel? product;

  @override
  State<ProductCRUDDialog> createState() => _ProductCRUDDialogState();
}

class _ProductCRUDDialogState extends State<ProductCRUDDialog> {
  final TextEditingController productnameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: "1");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.product != null) {
      productnameController.text = widget.product!.name.toString();
      productPriceController.text = widget.product!.price.toString();
      selectedCategoryId = widget.product!.category_id;
      category = widget.product!.category ?? "";
      isGram = widget.product!.is_gram;
      is_default = widget.product!.is_default ?? false;
      quantityController.text = widget.product!.qty.toString();

      print("selected category id : ${selectedCategoryId}");
    }
    setState(() {});
    super.initState();
  }

  bool isGram = false;
  int? selectedCategoryId;
  bool is_default = false;
  String category = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: widget.screenSize.width / 3.8,
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              padding: EdgeInsets.all(SizeConst.kHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///product name
                  Text(
                    "ပစ္စည်းအမည်",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 5),
                  TextFormField(
                    controller: productnameController,
                    validator: (value) {
                      if (value == "") {
                        return "Product Name can't be empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "Enter new product name",
                    ),
                  ),
                  SizedBox(height: 15),

                  ///product price
                  Text(
                    "စျေးနှုန်း",
                    //"Price",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 5),
                  TextFormField(
                    controller: productPriceController,
                    validator: (value) {
                      if (value == "") {
                        return "Product Price can't be empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "Enter price",
                    ),
                  ),

                  SizedBox(height: 15),
                  Text(
                    "အမျိုးအစား",
                    //"Category",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoadedState) {
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: ColorConstants.greyColor,
                            hintText: "${category}",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: SizeConst.kBorderRadius,
                              borderSide: BorderSide(
                                width: 0.5,
                                color: ColorConstants.greyColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: SizeConst.kBorderRadius,
                              borderSide: BorderSide(
                                width: 0.5,
                                color: ColorConstants.greyColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: SizeConst.kBorderRadius,
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: SizeConst.kBorderRadius,
                              borderSide: BorderSide(
                                width: 1,
                                color: ColorConstants.primaryColor,
                              ),
                            ),
                          ),
                          value: selectedCategoryId,
                          items: state.categoryList
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text("${e.name}"),
                                  value: e.id,
                                ),
                              )
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryId = newValue;
                              print(
                                  "selected category id : ${selectedCategoryId}");
                            });
                          },
                          validator: (value) {
                            if (selectedCategoryId == null) {
                              return 'Please select category';
                            }
                            return null;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),

                  ///is gran field
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isGram = !isGram;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          isGram
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isGram
                              ? ColorConstants.primaryColor
                              : Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text("ဂရမ်လား")
                      ],
                    ),
                  ),

                  ///is default field
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setState(() {
                        is_default = !is_default;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          is_default
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: is_default
                              ? ColorConstants.primaryColor
                              : Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text("Menu မှာ လိုအပ်ပါသလား။")
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      if (state is ProductsLoadingState) {
                        return loadingWidget();
                      } else {
                        return CancelAndConfirmDialogButton(
                          onConfirm: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.product != null) {
                                editProduct(
                                    product_id: widget.product!.id.toString());
                              } else {
                                createNewProduct();
                              }
                            }
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///create new product
  void createNewProduct() async {
    await context.read<ProductsCubit>().addNewProduct(
          requestBody: ProductModel(
                  category_id: selectedCategoryId ?? 000,
                  is_gram: isGram,
                  name: productnameController.text,
                  price: int.parse(
                    productPriceController.text,
                  ),
                  qty: 1,
                  is_default: is_default)
              .toJson(),
        );
  }

  ///edit product
  void editProduct({required String product_id}) async {
    await context.read<ProductsCubit>().updateProduct(
          requestBody: ProductModel(
            category_id: selectedCategoryId ?? 000,
            is_gram: isGram,
            name: productnameController.text,
            is_default: is_default,
            price: int.parse(
              productPriceController.text,
            ),
            qty: int.parse(
              quantityController.text,
            ),
          ).toJson(),
          id: product_id,
        );
  }
}
