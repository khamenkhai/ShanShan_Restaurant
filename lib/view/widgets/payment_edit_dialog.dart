import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/models/request_models/sale_request_model.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';

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
  bool paidOnline = false;
  bool paidCash = false;
  String paymentType = "";

  @override
  void initState() {
    super.initState();
    checKpaymentType();
  }

  int getCashAmount() {
    if (paidCash == true && paidOnline == false) {
      return widget.saleModel.grandTotal;
    } else {
      return 0;
    }
  }

  int getpaidOnline() {
    if (paidCash == false && paidOnline == true) {
      return widget.saleModel.grandTotal;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Text(
                tr(LocaleKeys.editPayment),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              /// Cash checkbox
              CheckboxListTile(
                title: const Text("Cash"),
                value: paidCash,
                onChanged: (value) {
                  setState(() {
                    paidCash = value!;
                    paidOnline = false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              /// Online checkbox
              CheckboxListTile(
                title: const Text("Online Pay"),
                value: paidOnline,
                onChanged: (value) {
                  setState(() {
                    paidOnline = value!;
                    paidCash = false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 30),

              /// Confirm buttons
              CancelAndConfirmDialogButton(
                onConfirm: () async {
                  if (paidCash && paidOnline) {
                    // Do nothing
                  } else {
                    await context
                        .read<SaleProcessCubit>()
                        .updateSale(
                          
                          saleRequest: widget.saleModel.copyWith(
                            paidCash: getCashAmount(),
                            paidOnline: getpaidOnline(),
                          ),
                        )
                        .then((value) {
                      if (!context.mounted) return;
                      Navigator.pop(
                        context,
                        getCashAmount() > getpaidOnline()
                            ? "Cash"
                            : "Online Pay",
                      );
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// to check the payment type
  void checKpaymentType() {
    if (widget.paymentType == "cash") {
      paidCash = true;
    }

    if (widget.paymentType == "Online Pay") {
      paidOnline = true;
    }

    if (widget.paymentType == "Cash / Online Pay") {
      paidOnline = false;
      paidCash = false;
    }

    setState(() {});
  }
}
