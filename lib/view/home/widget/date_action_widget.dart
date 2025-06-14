import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/core/utils/context_extension.dart';

class DateActionWidget extends StatelessWidget {
  const DateActionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E d, MMM yyyy').format(DateTime.now()),
            style: TextStyle(
              color: context.primaryColor,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 10),
          Icon(CupertinoIcons.calendar)
        ],
      ),
    );
  }
}
