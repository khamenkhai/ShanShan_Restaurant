import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.radius});
  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: color ?? Theme.of(context).primaryColor,
        radius: radius ?? 10,
      ),
    );
  }
}
