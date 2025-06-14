import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shan_shan/core/utils/context_extension.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.radius});
  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.waveDots(
        color: color ?? context.primaryColor,
        size: radius ?? 30,
      ),
    );
  }
}
