import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/models/data_models/remark_model.dart';
import 'package:shan_shan/view/payment/edit_bank.dart';
import 'package:shan_shan/view/payment/edit_bank_and_cash.dart';
import 'package:shan_shan/view/payment/edit_cash.dart';

class EditSaleCheckoutDialog extends StatefulWidget {
  const EditSaleCheckoutDialog({
    super.key,
    required this.onlinePayment,
    required this.paidCash,
    this.width,
    required this.orderNo,
    required this.octopusCount,
    required this.prawnCount,
    required this.date,
    required this.dineInOrParcel,
  });
  final bool onlinePayment;
  final bool paidCash;
  final double? width;
  final String orderNo;
  final int octopusCount;
  final int prawnCount;
  final String date;
  final int dineInOrParcel;
  @override
  State<EditSaleCheckoutDialog> createState() => _EditSaleCheckoutDialogState();
}

class _EditSaleCheckoutDialogState extends State<EditSaleCheckoutDialog> {
  bool isParcel = false;

  TextEditingController tableController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RemarkModel? remarkData;

  int prawnCount = 0;
  int octopusCount = 0;

  @override
  void initState() {
    isParcel = widget.dineInOrParcel == 0 ? true : false;
    prawnCount = widget.prawnCount;
    octopusCount = widget.octopusCount;
    remarkController.text = context.read<EditSaleCartCubit>().state.remark;
    tableController.text =
        context.read<EditSaleCartCubit>().state.tableNumber.toString();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditSaleCartCubit cartCubit = BlocProvider.of<EditSaleCartCubit>(context);

    var screenSize = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: SingleChildScrollView(
        child: BlocConsumer<EditSaleCartCubit, EditSaleCartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Container(
              width:
                  widget.width ?? screenSize.width / 3.8,
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "မှာယူမှု ",
                    style: TextStyle(
                        fontSize: 24- 5,
                        color: ColorConstants.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "စားပွဲနံပါတ်",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: tableController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value == "") {
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
                  ),

                  SizedBox(height: 15),

                  Text(
                    "ထိုင်စား or ပါဆယ်",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isParcel = false;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(isParcel
                            ? Icons.radio_button_off
                            : Icons.radio_button_checked),
                        SizedBox(width: 10),
                        Text("ထိုင်စား")
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isParcel = true;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(isParcel
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off),
                        SizedBox(width: 10),
                        Text("ပါဆယ်")
                      ],
                    ),
                  ),

                  SizedBox(height: 25),
                  Text(
                    "မှတ်ချက်",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextField(
                    controller: remarkController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "မှတ်ချက်ရေးရန်",
                      hintStyle: TextStyle(fontSize: 16 - 3),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),

                  SizedBox(height: 5),
                  _octopusCountRow(),
                  _prawnCount(),
                  SizedBox(height: 20),

                  ///buttons
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
                        child: Text("အတည်ပြုရန်"),
                        onPressed: () {
                          String remarkString = "${remarkController.text}";
                          context.read<EditSaleCartCubit>().addAdditionalData(
                                octopusCount: octopusCount,
                                prawnCount: prawnCount,
                                tableNumber: tableController.text == ""
                                    ? 0
                                    : int.parse(tableController.text),
                              );
                          if (_formKey.currentState!.validate()) {
                            if (widget.paidCash && !widget.onlinePayment) {
                              redirectTo(
                                context: context,
                                //replacement: true,
                                ///^^^^^^^^^^ important ^^^^^^^^^^
                                form: EditCashScreen(
                                  date: widget.date,
                                  octopusCount: octopusCount,
                                  prawnCount: prawnCount,
                                  orderNo: widget.orderNo,
                                  remark: remarkString,
                                  menu: cartCubit.state.menu!.name.toString(),
                                  athoneLevel:
                                      cartCubit.state.athoneLevel == null
                                          ? 000
                                          : cartCubit.state.athoneLevel!.id!,
                                  spicyLevel: cartCubit.state.spicyLevel == null
                                      ? 000
                                      : cartCubit.state.spicyLevel!.id!,
                                  menuId: cartCubit.state.menu!.id ,
                                  tableNumber: int.parse(tableController.text),
                                  dineInOrParcel: isParcel ? 0 : 1,
                                  subTotal: cartCubit.getTotalAmount(),
                                  tax: get5percentage(
                                      cartCubit.getTotalAmount()),
                                  paidCash: widget.paidCash,
                                ),
                              );
                            } else if (!widget.paidCash &&
                                widget.onlinePayment) {
                               redirectTo(
                                context: context,
                                //replacement: true,
                                form: EditOnlinePaymentScreen(
                                  date: widget.date,
                                  orderNo: widget.orderNo,
                                  menu: cartCubit.state.menu!.name.toString(),
                                  remark: remarkString,
                                  athoneLevel:
                                      cartCubit.state.athoneLevel == null
                                          ? 000
                                          : cartCubit.state.athoneLevel!.id!,
                                  spicyLevel: cartCubit.state.spicyLevel == null
                                      ? 000
                                      : cartCubit.state.spicyLevel!.id!,
                                  menuId: cartCubit.state.menu!.id ,
                                  tableNo: int.parse(tableController.text),
                                  dineInOrParcel: isParcel ? 0 : 1,
                                  subTotal: cartCubit.getTotalAmount(),
                                  tax: get5percentage(
                                      cartCubit.getTotalAmount()),
                                  prawnCount: prawnCount,
                                  octopusCount: octopusCount,
                                ),
                              );
                            } else if (widget.paidCash &&
                                widget.onlinePayment) {
                               redirectTo(
                                context: context,
                                form: EditMultiPaymentPage(
                                  date: widget.date,
                                  orderNo: widget.orderNo,
                                  menu: cartCubit.state.menu!.name.toString(),
                                  remark: remarkString,
                                  athoneLevel:
                                      cartCubit.state.athoneLevel == null
                                          ? 000
                                          : cartCubit.state.athoneLevel!.id!,
                                  spicyLevel: cartCubit.state.spicyLevel == null
                                      ? 000
                                      : cartCubit.state.spicyLevel!.id!,
                                  menuId: cartCubit.state.menu!.id ,
                                  tableNumber: int.parse(tableController.text),
                                  dineInOrParcel: isParcel ? 0 : 1,
                                  subTotal: cartCubit.getTotalAmount(),
                                  tax: get5percentage(
                                      cartCubit.getTotalAmount()),
                                  prawnCount: prawnCount,
                                  octopusCount: octopusCount,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ///octus count control row
  Row _octopusCountRow() {
    return Row(
      children: [
        Text(
          //"Octopus Count",
          "ရေဘဝဲ",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Spacer(),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            if (octopusCount == 0) {
            } else {
              setState(() {
                octopusCount -= 1;
              });
            }
          },
          icon: Icon(
            Icons.remove_circle,
          ),
        ),
        SizedBox(
          width: 20,
          child: Text(
            "${octopusCount}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            setState(() {
              octopusCount += 1;
            });
          },
          icon: Icon(
            Icons.add_circle,
          ),
        ),
      ],
    );
  }

  Row _prawnCount() {
    return Row(
      children: [
        Text(
          "ပုဇွန်",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Spacer(),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            if (prawnCount == 0) {
            } else {
              setState(() {
                prawnCount -= 1;
              });
            }
          },
          icon: Icon(
            Icons.remove_circle,
          ),
        ),
        SizedBox(
          width: 20,
          child: Text(
            "${prawnCount}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            setState(() {
              prawnCount += 1;
            });
          },
          icon: Icon(
            Icons.add_circle,
          ),
        ),
      ],
    );
  }
}
