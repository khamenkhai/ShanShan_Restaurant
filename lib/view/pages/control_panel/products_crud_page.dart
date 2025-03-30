import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/model/response_models/product_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/product_card_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/products_curd_dialog.dart';

class ProductCRUDPage extends StatefulWidget {
  const ProductCRUDPage({super.key, required this.title});
  final String title;

  @override
  State<ProductCRUDPage> createState() => _ProductCRUDPageState();
}

class _ProductCRUDPageState extends State<ProductCRUDPage> {
  var categoryNameController = TextEditingController();
  var productPriceController = TextEditingController();

  @override
  void initState() {
    context.read<ProductsCubit>().getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        centerTitle: true,
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("${widget.title}"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        label: Text("ပစ္စည်းအသစ်ထည့်ရန်"),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ProductCRUDDialog(
                screenSize: screenSize,
              );
            },
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConst.kHorizontalPadding,
        ),
        child: _productListWidget(
          screenSize,
        ),
      ),
    );
  }

  Widget _productListWidget(Size screenSize) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return loadingWidget();
        } else if (state is ProductsLoadedState) {
          return state.products.length > 0
              ? GridView.builder(
                  
                  padding: EdgeInsets.only(bottom: 20, top: 7.5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: SizeConst.kHorizontalPadding,
                    crossAxisSpacing: SizeConst.kHorizontalPadding,
                    childAspectRatio: screenSize.width * 0.002,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    ProductModel product = state.products[index];
                    return Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: SizeConst.kBorderRadius,
                      ),
                      child: productCardWidget(
                        product: product,
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ProductCRUDDialog(
                                screenSize: screenSize,
                                product: product,
                              );
                            },
                          );
                        },
                        onDelete: () {
                          _deleteWarningDialog(
                            context: context,
                            screenSize: screenSize,
                            productId: product.id.toString(),
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "ထုတ်ကုန်မရှိပါ။!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  ///delete category warning dialog box
  Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String productId,
  }) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoadingState) {
            return loadingWidget();
          } else {
            return CancelAndDeleteDialogButton(
              onDelete: () async {
                await _deleteProductData(context, productId);
              },
            );
          }
        },
      ),
    );
  }

  ///delete product data
  Future<void> _deleteProductData(
    BuildContext context,
    String productId,
  ) async {
    await context.read<ProductsCubit>().deleteProduct(id: productId);
  }
}
