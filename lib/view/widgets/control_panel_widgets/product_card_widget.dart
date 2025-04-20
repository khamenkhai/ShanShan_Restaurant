import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/response_models/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConst.kHorizontalPadding - 3,
        bottom: SizeConst.kHorizontalPadding - 3,
        left: 15,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: SizeConst.kBorderRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!.length > 20
                        ? "${product.name}..".substring(0, 20)
                        : "${product.name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${formatNumber(product.price as num)} MMK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              InkWell(
                onTap: onDelete,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    CupertinoIcons.delete,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
