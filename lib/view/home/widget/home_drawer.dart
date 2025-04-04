import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shan_shan/controller/auth_cubit/auth_cubit.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/view/control_panel/pages/control_panel.dart';
import 'package:shan_shan/view/history/history.dart';
import 'package:shan_shan/view/sale_report/sale_report_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.onNavigate});

  final Function() onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0)
      ),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear),
                )
              ],
            ),

            Container(height: 200),

            ///control panel
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                redirectTo(context: context, form: ControlPanel());

                onNavigate();
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.settings)),
              title: Text("ထိန်းချုပ်ရာနေရာ"),
            ),
            SizedBox(height: 10),

            ///report
            ListTile(
              onTap: () {
                Navigator.pop(context);
                redirectTo(context: context, form: ReportPage());
                onNavigate();
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.square_stack)),
              title: Text("အရောင်းအစီရင်ခံစာ"),
            ),
            SizedBox(height: 10),

            ///history
            ListTile(
              onTap: () {
                Navigator.pop(context);
                redirectTo(
                  context: context,
                  form: SalesHistoryPage(),
                );
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.doc)),
              title: Text("အရောင်းမှတ်တမ်း"),
            ),

            SizedBox(height: 10),

            ///logout
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return _logoutDialogBox(context);
                  },
                );
              },
              leading: CircleAvatar(
                child: Icon(IconlyLight.logout),
              ),
              title: Text("ထွက်ရန်"),
            ),
          ],
        ),
      ),
    );
  }

  ///logout dialog box
  Dialog _logoutDialogBox(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.85,
        padding: EdgeInsets.only(
          left: SizeConst.kHorizontalPadding,
          right: SizeConst.kHorizontalPadding,
          bottom: SizeConst.kHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(bottom: 25, top: 15),
              child: Text(
                "ထွက်ဖို့သေချာပါသလား ?",
                style: TextStyle(
                  color: ColorConstants.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomOutlineButton(
                    bgColor: Colors.white,
                    elevation: 0,
                    height: 60,
                    child: Text("ပယ်ဖျက်ပါ"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomElevatedButton(
                    bgColor: ColorConstants.primaryColor,
                    elevation: 0,
                    height: 60,
                    child: Text("ထွက်ရန်"),
                    onPressed: () async {
                      logout(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///logout process
  void logout(BuildContext context) async {
    bool logoutStatus =
        await context.read<AuthCubit>().logout();
    if (logoutStatus) {
       if(!context.mounted) return;
      context.read<CartCubit>().clearOrder();
      context.read<EditSaleCartCubit>().clearOrderr();
    }
  }
}
