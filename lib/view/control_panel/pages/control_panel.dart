import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/view/control_panel/pages/htone_level_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/categories_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/menu_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/products_control_page.dart';
import 'package:shan_shan/view/control_panel/pages/spicy_level_control_page.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

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
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("ထိန်းချုပ်ရာနေရာ"),
      ),
      body: _mainForm(context),
    );
  }

  ///main form
  Container _mainForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: Column(
        children: [
          Row(
            children: [
              _cardWidget(
                name: "ပစ္စည်းများ",
                redirectForm: ProductsControlPage(
                  title: "ပစ္စည်းများ",
                ),
                widget: Icon(
                  CupertinoIcons.bag,
                  size: 35,
                ),
              ),
              SizedBox(width: SizeConst.kHorizontalPadding),
              _cardWidget(
                name: "အမျိုးအစားများ",
                redirectForm: CategoriesControlPage(title: "အမျိုးအစားများ"),
                widget: Icon(
                  CupertinoIcons.square_list,
                  size: 35,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConst.kHorizontalPadding),
          Row(
            children: [
              _cardWidget(
                name: "မီနူး",
                redirectForm: MenuCRUDScreen(title: "မီနူး"),
                widget: Icon(
                  CupertinoIcons.bars,
                  size: 35,
                ),
              ),
              SizedBox(width: SizeConst.kHorizontalPadding),
              _cardWidget(
                name: "အထုံ Level",
                redirectForm: HtoneLevelControlPage(
                  title: "အထုံ Level",
                ),
                widget: Icon(
                  Icons.soup_kitchen,
                  size: 35,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConst.kHorizontalPadding),
          Row(
            children: [
              _cardWidget(
                name: "အစပ် Level",
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
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          redirectTo(
            context: context,
            form: redirectForm,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: SizeConst.kBorderRadius,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                child: widget,
              ),
              SizedBox(width: 15),
              Text(
                "$name",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
