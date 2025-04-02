import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/view/common_widgets/custom_dialog.dart';

class TableNumberDialog extends StatelessWidget {
  final TextEditingController tableController;

  const TableNumberDialog({
    super.key,
    required this.tableController,
  });

  @override
  Widget build(BuildContext context) {
    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CustomDialog(
        child: BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state.tableNumber == 0) {
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.clear),
                    ),
                  ],
                ),
                Text(
                  "စားပွဲနံပါတ်",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: tableController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "စားပွဲနံပါတ် လိုအပ်ပါသည်။!";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "စားပွဲနံပါတ်ရေးရန်",
                    hintStyle: TextStyle(fontSize: 16 - 3),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        cartCubit.addTableNumber(
                          tableNumber: int.parse(tableController.text),
                        );

                        if (cartCubit.state.tableNumber != 0) {
                          Navigator.pop(context);
                        } else {
                          customPrint(
                              "table number : ${cartCubit.state.tableNumber}");
                        }
                        tableController.clear();
                      },
                      child: Text("အတည်ပြုရန်"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
