import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/model/response_models/category_model.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/product_list_widget.dart';

class CategoryBoxWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final CategoryModel category;
  final CartItem? defaultItem;
  final TextEditingController tableController;
  
  const CategoryBoxWidget({
    super.key,
    required this.constraints,
    required this.category,
    required this.defaultItem,
    required this.tableController,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: SizeConst.kBorderRadius,
      color: Colors.white,
      child: Container(
        width: (constraints.maxWidth / 2),
        height: constraints.maxHeight / 1.2,
        decoration: BoxDecoration(
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: Center(
                child: Text(
                  category.name ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: const Divider(height: 0, thickness: 1),
            ),
            _buildProductList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return LoadingWidget();
        } else if (state is ProductsLoadedState) {
          final productList = state.products
              .where((element) => element.category == category.name)
              .toList();

          return productListScrollBar(
            productList: productList,
            context: context,
            scrollController: ScrollController(),
            tableController: tableController,
            isEditState: false,
          );
        }
        return const Text("No products available");
      },
    );
  }
}