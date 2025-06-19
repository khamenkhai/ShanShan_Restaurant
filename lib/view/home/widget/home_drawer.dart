import 'package:easy_localization/easy_localization.dart';
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
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/view/auth/login.dart';
import 'package:shan_shan/view/control_panel/pages/control_panel.dart';
import 'package:shan_shan/view/history/history.dart';
import 'package:shan_shan/view/localization/localization.dart';
import 'package:shan_shan/view/sale_report/sale_report_page.dart';
import 'package:shan_shan/view/theme/theme_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.onNavigate});

  final Function() onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
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

            Container(height: 150),

            ///control panel
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                redirectTo(context: context, form: ControlPanel());

                onNavigate();
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.settings)),
              title: Text(tr(LocaleKeys.controlPanel)),
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
              title: Text(tr(LocaleKeys.saleReport)),
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
              title: Text(tr(LocaleKeys.saleHistory)),
            ),

            SizedBox(height: 10),

            /// language
            ListTile(
              onTap: () {
                Navigator.pop(context);
                redirectTo(
                  context: context,
                  form: LocalizationPage(),
                );
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.globe)),
              title: Text(tr(LocaleKeys.language)),
            ),
            SizedBox(height: 10),

            /// theme
            ListTile(
              onTap: () {
                Navigator.pop(context);
                redirectTo(
                  context: context,
                  form: ColorPickerScreen(),
                );
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.color_filter)),
              title: Text(tr(LocaleKeys.themeColor)),
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
              title: Text(tr(LocaleKeys.logout)),
            ),
          ],
        ),
      ),
    );
  }

  ///logout dialog box
  Dialog _logoutDialogBox(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      backgroundColor: Theme.of(context).cardColor,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.85,
        padding: EdgeInsets.only(
          left: SizeConst.kGlobalPadding,
          right: SizeConst.kGlobalPadding,
          bottom: SizeConst.kGlobalPadding,
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
                "Are you sure to logout?",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
                    child: Text(tr(LocaleKeys.cancel)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomElevatedButton(
                    bgColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    height: 60,
                    child: Text(tr(LocaleKeys.confirm)),
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
    bool logoutStatus = await context.read<AuthCubit>().logout();
    // if(!context.mounted) return;
    // ignore: use_build_context_synchronously
    NavigationHelper.pushReplacement(context, Login());
    if (logoutStatus) {
      if (!context.mounted) return;
      context.read<CartCubit>().clearOrder();
      context.read<EditSaleCartCubit>().clearOrder();
    }

  }
}
