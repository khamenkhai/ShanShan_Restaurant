import 'package:flutter/material.dart';
import 'package:shan_shan/models/response_models/product_model.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/product_row_widget.dart';

///product list widget (display with scrollbar)
Widget productListScrollBar({
  required List<ProductModel> productList,
  required ScrollController scrollController,
  required TextEditingController tableController,
  required BuildContext context,
  required bool isEditState,
}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.only(right: 0, bottom: 10),
      child: Scrollbar(
        //thumbVisibility: true,
        thickness: 4,
        controller: scrollController,
        radius: Radius.circular(25),
        child: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: productList
                .map(
                  (e) => productRowWidget(
                    product: e,
                    context: context,
                    tableController: tableController,
                    isEditState: isEditState,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ),
  );
}
