import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/category_model.dart';
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
      color: Theme.of(context).cardColor,
      child: Container(
        width: ((constraints.maxWidth - SizeConst.kHorizontalPadding) / 2),
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
            ProductListScrollBar(
              tableController: tableController,
              isEditState: false,
            ),
          ],
        ),
      ),
    );
  }
}
