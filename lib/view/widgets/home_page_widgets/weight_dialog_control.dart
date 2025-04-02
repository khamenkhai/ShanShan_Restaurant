// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/common_widgets/custom_dialog.dart';

// ignore: must_be_immutable
class CartItemWeightControlDialog extends StatefulWidget {
  CartItemWeightControlDialog(
      {super.key,
      required this.screenSizeWidth,
      required this.weightGram,
      required this.cartItem,
      required this.isEditState});
  final double screenSizeWidth;
  int weightGram;
  final CartItem cartItem;
  final bool isEditState;

  @override
  State<CartItemWeightControlDialog> createState() =>
      _CartItemWeightControlDialogState();
}

class _CartItemWeightControlDialogState
    extends State<CartItemWeightControlDialog> {
  TextEditingController gram = TextEditingController();

  @override
  void initState() {
    gram.text = "${widget.weightGram}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${widget.cartItem.name}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 15),
          _weightControl(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              customizableOTButton(
                elevation: 0,
                child: Text("ပယ်ဖျက်ရန်"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 10),
              CustomElevatedButton(
                elevation: 0,
                child: Text("အပ်ဒိတ်လုပ်ရန်"),
                onPressed: () {
                  if (widget.isEditState) {
                    context.read<EditSaleCartCubit>().addToCartByGram(
                          item: widget.cartItem,
                          gram: int.parse(gram.text),
                        );
                  } else {
                    context.read<CartCubit>().addToCartByGram(
                          item: widget.cartItem,
                          gram: int.parse(gram.text),
                        );
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  ///weight control widget
  Center _weightControl() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                num value = num.parse(gram.text);
                if (value > 0) {
                  value -= 100;
                  gram.text = value.toString();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.remove,
                color: Colors.black,
                weight: 10,
              ),
            ),
          ),
          SizedBox(width: 30),
          SizedBox(
            width: 100,
            child: TextField(
              controller: gram,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ),
          Text("/g"),
          SizedBox(width: 30),
          InkWell(
            onTap: () {
              setState(() {
                num value = num.parse(gram.text);
                value += 100;
                gram.text = value.toString();
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
