import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/model/request_models/sale_request_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/payment_button.dart';

class PaymentEditDialog extends StatefulWidget {
  const PaymentEditDialog({
    super.key,
    required this.paymentType,
    required this.saleModel,
  });
  final String paymentType;
  final SaleModel saleModel;

  @override
  State<PaymentEditDialog> createState() => _PaymentEditDialogState();
}

class _PaymentEditDialogState extends State<PaymentEditDialog> {
  bool KpayPayment = false;
  bool cashPayment = false;
  String paymentType = "";

  @override
  void initState() {
    checKpaymentType();
    super.initState();
  }

  int getCashAmount() {
    if (cashPayment == true && KpayPayment == false) {
      return widget.saleModel.grand_total;
    } else {
      return 0;
    }
  }

  int getKpayAmount() {
    if (cashPayment == false && KpayPayment == true) {
      return widget.saleModel.grand_total;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.8,
        padding: EdgeInsets.symmetric(
            horizontal: 15, vertical: SizeConst.kHorizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            SizedBox(height: 10),
            Text(
              "ငွေပေးချေမှုကို edit လုပ်ရန်",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        cashPayment = !cashPayment;
                        KpayPayment = false;
                      });
                    },
                    child: PaymentButton(
                      isSelected: cashPayment,
                      title: "Cash",
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        KpayPayment = !KpayPayment;
                        cashPayment = false;
                      });
                    },
                    child: PaymentButton(
                      isSelected: KpayPayment,
                      title: "KBZ Pay",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                custamizableElevated(
                  child: Text("အတည်ပြုရန်"),
                  onPressed: () async {
                    if (cashPayment && KpayPayment) {
                    } else {
                      await context
                          .read<SaleProcessCubit>()
                          .updateSale(
                            orderId: widget.saleModel.order_no,
                            saleRequest: widget.saleModel.copyWith(
                              paid_cash: getCashAmount(),
                              paid_online: getKpayAmount(),
                            ),
                          )
                          .then(
                        (value) {
                          Navigator.pop(
                            context,
                            getCashAmount() > getKpayAmount() ? "cash" : "Kpay",
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ///to check the payment type
  void checKpaymentType() {
    if (widget.paymentType == "cash") {
      cashPayment = true;
    }

    if (widget.paymentType == "Kpay") {
      KpayPayment = true;
    }
    if (widget.paymentType == "Cash / Kpay") {
      KpayPayment = false;
      cashPayment = false;
    }

    setState(() {});
  }
}
