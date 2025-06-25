import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:shan_shan/controller/auth_cubit/auth_cubit.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
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
              leading: CircleAvatar(child: Icon(IconlyLight.setting)),
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
              leading: CircleAvatar(child: Icon(IconlyBold.chart)),
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
              leading: CircleAvatar(child: Icon(IconlyLight.document)),
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
              leading: CircleAvatar(child: Icon(IconlyLight.more_circle)),
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
              leading: CircleAvatar(child: Icon(IconlyLight.category )),
              title: Text(tr(LocaleKeys.themeColor)),
            ),

            SizedBox(height: 10),

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
  AlertDialog _logoutDialogBox(BuildContext context) {
    return AlertDialog(
      title: Text(tr(LocaleKeys.confirmLogout), style: context.subTitle()),
      content: Text(tr(LocaleKeys.areYouSureToLogout)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(tr(LocaleKeys.cancel)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 10),
            TextButton(
              child: Text(tr(LocaleKeys.confirm)),
              onPressed: () async {
                logout(context);
              },
            )
          ],
        ),
      ],
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
      context.read<OrderEditCubit>().clearOrder();
    }
  }
}
