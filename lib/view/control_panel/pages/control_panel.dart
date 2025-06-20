import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/scale_on_tap.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/view/control_panel/pages/htone_level_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/categories_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/menu_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/products_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/spicy_level_control_page.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        centerTitle: true,
        leading: AppBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(tr(LocaleKeys.controlPanel)),
      ),
      body: _mainForm(context),
    );
  }

  ///main form
  Container _mainForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kGlobalPadding),
      child: Column(
        children: [
          Row(
            children: [
              _cardWidget(
                name: tr(LocaleKeys.products),
                redirectForm: ProductsControlPage(),
                widget: Icon(
                  CupertinoIcons.bag,
                  size: 35,
                ),
              ),
              SizedBox(width: SizeConst.kGlobalPadding),
              _cardWidget(
                name: tr(LocaleKeys.categories),
                redirectForm: CategoriesControlPage(),
                widget: Icon(
                  CupertinoIcons.square_list,
                  size: 35,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConst.kGlobalPadding),
          Row(
            children: [
              _cardWidget(
                name: tr(LocaleKeys.menu),
                redirectForm: MenuCRUDScreen(),
                widget: Icon(
                  CupertinoIcons.bars,
                  size: 35,
                ),
              ),
              SizedBox(width: SizeConst.kGlobalPadding),
              _cardWidget(
                name: tr(LocaleKeys.htoneLevel),
                redirectForm: HtoneLevelControlPage(),
                widget: Icon(
                  Icons.soup_kitchen,
                  size: 35,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConst.kGlobalPadding),
          Row(
            children: [
              _cardWidget(
                name: tr(LocaleKeys.spicyLevel),
                redirectForm: SpicyLevelScreen(),
                widget: Icon(
                  CupertinoIcons.flame,
                  size: 35,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// title categories card widget
  Widget _cardWidget({
    required String name,
    required Widget widget,
    required Widget redirectForm,
  }) {
    return Expanded(
      child: ScaleOnTap(
        onTap: () {
          NavigationHelper.pushPage(context, redirectForm);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
            
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  child: widget,
                ),
                SizedBox(width: 15),
                Text(
                  name,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
