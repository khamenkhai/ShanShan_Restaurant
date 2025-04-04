// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/view/common_widgets/custom_dialog.dart';

// ignore: must_be_immutable
class CartItemQtyDialogControl extends StatefulWidget {
  CartItemQtyDialogControl({
    super.key,
    required this.screenSizeWidth,
    required this.quantity,
    required this.cartItem,
    required this.isEditState,
  });
  final double screenSizeWidth;
  int quantity;
  final CartItem cartItem;
  final bool isEditState;

  @override
  State<CartItemQtyDialogControl> createState() =>
      _CartItemQtyDialogControlState();
}

class _CartItemQtyDialogControlState extends State<CartItemQtyDialogControl> {
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

          _quantityControl(),

          //_levelChoose(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomOutlineButton(
                elevation: 0,
                child: Text("ပယ်ဖျက်ရန်"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 10),
              CustomElevatedButton(
                child: Text("အပ်ဒိတ်လုပ်ရန်"),
                onPressed: () {
                  if (widget.isEditState) {
                    context.read<EditSaleCartCubit>().changeQuantity(
                          item: widget.cartItem,
                          quantity: widget.quantity,
                        );
                  } else {
                    context.read<CartCubit>().changeQuantity(
                          item: widget.cartItem,
                          quantity: widget.quantity,
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
  Center _quantityControl() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (widget.quantity > 1) {
                widget.quantity--;
                setState(() {});
              }
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
          Center(
            child: SizedBox(
              width: 70,
              child: Text(
                "${widget.quantity}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(width: 30),
          InkWell(
            onTap: () {
              widget.quantity++;
              setState(() {});
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
