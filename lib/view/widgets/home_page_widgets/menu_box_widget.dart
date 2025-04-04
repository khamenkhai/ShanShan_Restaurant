import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/view/widgets/home_page_widgets/menu_row_widget.dart';

class MenuBoxWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final CartItem? defaultItem;

  const MenuBoxWidget({
    super.key,
    required this.constraints,
    this.defaultItem,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: SizeConst.kBorderRadius,
      color: Colors.white,
      child: Container(
        width: constraints.maxWidth,
        decoration: BoxDecoration(
          borderRadius: SizeConst.kBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const SizedBox(
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
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: const Divider(
                height: 0,
                thickness: 1,
              ),
            ),
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                if (state is MenuLoadingState) {
                  return const LoadingWidget();
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
                              (e) => MenuRowWidget(
                                menu: e,
                                defaultItem: defaultItem,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                } else {
                  return const Text("");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
