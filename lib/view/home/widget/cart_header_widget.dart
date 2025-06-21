import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/context_extension.dart';

class CartHeaderWidget extends StatelessWidget {
  final VoidCallback onClearOrder;

  const CartHeaderWidget({
    super.key,
    required this.onClearOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(SizeConst.radius)),
          child: Icon(
            IconlyBold.buy,
            size: 20,
            color: context.cardColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(tr(LocaleKeys.lblOrder), style: context.subTitle()),
        const Spacer(),
        TextButton(
          onPressed: onClearOrder,
          style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
          child: Text(tr(LocaleKeys.clearCart)),
        )
      ],
    );
  }
}
