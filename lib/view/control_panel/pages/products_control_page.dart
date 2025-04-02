import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/view/control_panel/widgets/products_curd_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/model/response_models/product_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/product_card_widget.dart';


class ProductsControlPage extends StatefulWidget {
  const ProductsControlPage({super.key, required this.title});
  final String title;

  @override
  State<ProductsControlPage> createState() => _ProductsControlPageState();
}

class _ProductsControlPageState extends State<ProductsControlPage> {
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
        leading: appBarLeading(onTap: () => Navigator.pop(context)),
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        label: const Text("ပစ္စည်းအသစ်ထည့်ရန်"),
        icon: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ProductCRUDDialog(screenSize: screenSize),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
        child: _productListWidget(screenSize),
      ),
    );
  }

  /// Widget for displaying product list with skeleton loader
  Widget _productListWidget(Size screenSize) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return Skeletonizer(
            enabled: true,
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 20, top: 7.5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: SizeConst.kHorizontalPadding,
                crossAxisSpacing: SizeConst.kHorizontalPadding,
                childAspectRatio: screenSize.width * 0.002,
              ),
              itemCount: 8, // Simulating 8 skeleton items
              itemBuilder: (context, index) => ProductCardWidget(
                product: ProductModel(
                    category: "",
                    categoryId: 1,
                    id: 1,
                    isDefault: true,
                    isGram: false,
                    name: "Testing Product",
                    price: 100,
                    qty: 1),
                onDelete: () {},
                onEdit: () {},
              ),
            ),
          );
        } else if (state is ProductsLoadedState && state.products.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 20, top: 7.5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: SizeConst.kHorizontalPadding,
              crossAxisSpacing: SizeConst.kHorizontalPadding,
              childAspectRatio: screenSize.width * 0.002,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              ProductModel product = state.products[index];
              return ProductCardWidget(
                product: product,
                onEdit: () => showDialog(
                  context: context,
                  builder: (context) => ProductCRUDDialog(
                    screenSize: screenSize,
                    product: product,
                  ),
                ),
                onDelete: () => _deleteWarningDialog(
                  context,
                  screenSize,
                  product.id.toString(),
                ),
              );
            },
          );
        }
        return const Center(
            child: Text("ထုတ်ကုန်မရှိပါ။!", style: TextStyle(fontSize: 16)));
      },
    );
  }

  /// Displays delete warning dialog
  Future<void> _deleteWarningDialog(
    BuildContext context,
    Size screenSize,
    String productId,
  ) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) => state is ProductsLoadingState
            ? const CircularProgressIndicator()
            : CancelAndDeleteDialogButton(
                onDelete: () => _deleteProductData(
                  context,
                  productId,
                ),
              ),
      ),
    );
  }

  /// Deletes the product
  Future<void> _deleteProductData(
    BuildContext context,
    String productId,
  ) async {
    await context.read<ProductsCubit>().deleteProduct(id: productId).then((d){
      if(!context.mounted) return;
      Navigator.pop(context);
    });
  }
}


