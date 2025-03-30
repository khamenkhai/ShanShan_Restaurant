import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/core/const/const_export.dart';import 'package:shan_shan/model/response_models/cart_item_model.dart';
import 'package:shan_shan/model/response_models/menu_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/menu_row_widget.dart';

///menu box widget
Widget menuBoxWidget({
  required BoxConstraints constraints,
  CartItem? defaultItem,
}) {
  return Material(
    borderRadius: SizeConst.kBorderRadius,
    color: Colors.white,
    child: Container(
      width: (constraints.maxWidth / 2) - (SizeConst.kHorizontalPadding),
      height: constraints.maxHeight / 1.2,
      decoration: BoxDecoration(
        borderRadius: SizeConst.kBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            height: 38,
            child: Center(
              child: Text(
                "မီနူး",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: Divider(
              height: 0,
              thickness: 1,
            ),
          ),
          Expanded(
            child: BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                if (state is MenuLoadingState) {
                  return loadingWidget();
                } else if (state is MenuLoadedState) {
                  List<MenuModel> menuList = state.menuList;

                  return Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 10),
                    child: SingleChildScrollView(
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: menuList
                            .map(
                              (e) => menuRowWidget(
                                menu: e,
                                context: context,
                                defaultItem: defaultItem,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return Text("");
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}
