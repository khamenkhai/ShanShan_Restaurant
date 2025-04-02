import 'package:flutter/cupertino.dart';
import 'package:shan_shan/core/const/color_const.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.radius = 15});
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: color ?? ColorConstants.primaryColor,
        radius: radius,
      ),
    );
  }
}
