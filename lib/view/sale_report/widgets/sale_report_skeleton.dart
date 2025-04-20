import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportSummarySkeleton extends StatelessWidget {
  const ReportSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Theme.of(context).cardColor;
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSkeletonCard(cardColor),
                const SizedBox(width: 15),
                _buildSkeletonCard(cardColor),
                const SizedBox(width: 15),
                _buildSkeletonCard(cardColor),
              ],
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCard(Color cardColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: SizeConst.kBorderRadius,
          color: cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.circle, size: 30),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey[200],
                )
              ],
            ),
            const SizedBox(height: 15),
            Container(
              width: 120,
              height: 24,
              color: Colors.grey[200],
            )
          ],
        ),
      ),
    );
  }
}
