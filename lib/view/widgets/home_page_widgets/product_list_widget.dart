import 'package:flutter/material.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/models/response_models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/view/widgets/product_detail_control.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductListScrollBar extends StatelessWidget {
  final TextEditingController tableController;
  final bool isEditState;
  final int categoryId;

  ProductListScrollBar({
    super.key,
    required this.tableController,
    required this.isEditState,
    required this.categoryId,
  });

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 0, bottom: 10),
        child: Scrollbar(
          thickness: 4,
          controller: scrollController,
          radius: const Radius.circular(25),
          child: SingleChildScrollView(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoadingState) {
                  return Skeletonizer(
                    enabled: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ProductRowWidget(
                          product: ProductModel(name: "---------"),
                          tableController: tableController,
                          isEditState: isEditState,
                        ),
                        ProductRowWidget(
                          product: ProductModel(name: "---------"),
                          tableController: tableController,
                          isEditState: isEditState,
                        ),
                        ProductRowWidget(
                          product: ProductModel(name: "---------"),
                          tableController: tableController,
                          isEditState: isEditState,
                        ),
                        ProductRowWidget(
                          product: ProductModel(name: "---------"),
                          tableController: tableController,
                          isEditState: isEditState,
                        ),
                      ],
                    ),
                  );
                } else if (state is ProductsLoadedState) {
                  List<ProductModel> productList = state.products
                      .where((element) => element.categoryId == categoryId)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: productList
                        .map(
                          (e) => ProductRowWidget(
                            product: e,
                            tableController: tableController,
                            isEditState: isEditState,
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProductRowWidget extends StatelessWidget {
  final ProductModel product;
  final TextEditingController tableController;
  final bool isEditState;

  const ProductRowWidget({
    super.key,
    required this.product,
    required this.tableController,
    required this.isEditState,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.primaryColor.withValues(alpha: 0.3),
      onTap: () {
        if (isEditState) {
          showDialog(
            context: context,
            builder: (context) => ProductWeightOrDetailControl(
              product: product,
              isEditState: isEditState,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => ProductWeightOrDetailControl(
              product: product,
              isEditState: isEditState,
            ),
          );
        }
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: SizeConst.kGlobalPadding),
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.name ?? "",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "${product.price} MMK",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
