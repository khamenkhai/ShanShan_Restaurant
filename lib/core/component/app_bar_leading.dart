import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shan_shan/core/component/scale_on_tap.dart';
import 'package:shan_shan/core/const/size_const.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading(
      {super.key,
      required this.onTap,
      this.padding = SizeConst.kGlobalPadding});
  final VoidCallback onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: padding),
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              padding: EdgeInsets.only(
                left: 13,
                right: 13,
                top: 5,
                bottom: 5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: SizeConst.kBorderRadius,
              ),
              child: Center(
                child: Icon(
                  IconlyBold.arrow_left_2,
                  // size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
