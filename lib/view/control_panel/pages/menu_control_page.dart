import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/custom_dialog.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/view/control_panel/widgets/common_crud_card.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MenuCRUDScreen extends StatefulWidget {
  const MenuCRUDScreen({super.key});

  @override
  State<MenuCRUDScreen> createState() => _MenuCRUDScreenState();
}

class _MenuCRUDScreenState extends State<MenuCRUDScreen> {
  @override
  void initState() {
    context.read<MenuCubit>().getMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        centerTitle: true,
        leading: AppBarLeading(
          onTap: () => Navigator.pop(context),
        ),
        title: Text(tr(LocaleKeys.menu)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(tr(LocaleKeys.addNewMenu)),
        icon: const Icon(Icons.add),
        onPressed: () => _showMenuDialog(screenSize),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConst.kGlobalPadding),
        child: _buildMenuList(screenSize),
      ),
    );
  }

  Widget _buildMenuList(Size screenSize) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is MenuLoadingState) {
          return Skeletonizer(
            enabled: true,
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 20, top: 7.5),
              gridDelegate: _gridDelegate(screenSize),
              itemCount: 5,
              itemBuilder: (context, index) {
                return CrudCard(title: "Hello world");
              },
            ),
          );
        } else if (state is MenuLoadedState) {
          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 20, top: 7.5),
            gridDelegate: _gridDelegate(screenSize),
            itemCount: state.menuList.length,
            itemBuilder: (context, index) {
              MenuModel menu = state.menuList[index];
              return Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: SizeConst.kBorderRadius,
                ),
                child: CrudCard(
                  title: menu.name ?? "",
                  onDelete: () => _showDeleteDialog(
                      context, screenSize, menu.id.toString()),
                  onEdit: () => _showMenuDialog(screenSize, menu: menu),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _gridDelegate(Size screenSize) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: SizeConst.kGlobalPadding,
      crossAxisSpacing: SizeConst.kGlobalPadding,
      childAspectRatio: screenSize.width * 0.002,
    );
  }

  void _showMenuDialog(Size screenSize, {MenuModel? menu}) {
    showDialog(
      context: context,
      builder: (context) => MenuCRUDScreenDialog(
        screenSize: screenSize,
        menu: menu,
      ),
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, Size screenSize, String menuId) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              const Text("ဖျက်ရန် သေချာလား", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 15),
              BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state is MenuLoadingState) {
                    return const LoadingWidget();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomOutlineButton(
                        elevation: 0,
                        child: Text(tr(LocaleKeys.cancel)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      CustomElevatedButton(
                        bgColor: Colors.red,
                        child: const Text("ဖျက်မည်"),
                        onPressed: () async {
                          Navigator.pop(context);
                          context.read<MenuCubit>().deleteMenu(id: menuId);
                        },
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

////menu crud dialob box
class MenuCRUDScreenDialog extends StatefulWidget {
  const MenuCRUDScreenDialog({
    super.key,
    required this.screenSize,
    this.menu,
  });

  final Size screenSize;

  final MenuModel? menu;

  @override
  State<MenuCRUDScreenDialog> createState() => _MenuCRUDScreenDialogState();
}

class _MenuCRUDScreenDialogState extends State<MenuCRUDScreenDialog> {
  final TextEditingController menuNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  @override
  void initState() {
    if (widget.menu != null) {
      menuNameController.text = widget.menu!.name.toString();
    }
    resetPage();
    super.initState();
  }

  void resetPage() {
    setState(() {});
  }

  bool isTaseRequired = false;

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ///menu name
              Text(
                tr(LocaleKeys.menu),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 10),
              TextFormField(
                controller: menuNameController,
                validator: (value) {
                  if (value == "") {
                    return "Menu Name can't be empty";
                  }
                  return null;
                },
                decoration: customTextDecoration2(
                    labelText: "မီနူးအမည်အသစ်",
                    primaryColor: Theme.of(context).primaryColor),
              ),

              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  isTaseRequired = !isTaseRequired;
                  resetPage();
                },
                child: Row(
                  children: [
                    Icon(
                      isTaseRequired
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color:
                          isTaseRequired ? context.primaryColor : Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(tr(LocaleKeys.noChoosingTasteLevels))
                  ],
                ),
              ),

              SizedBox(height: 15),

              BlocConsumer<MenuCubit, MenuState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is MenuLoadingState) {
                    return LoadingWidget();
                  } else {
                    return CancelAndConfirmDialogButton(
                      onConfirm: () async {
                        if (widget.menu != null) {
                          await context
                              .read<MenuCubit>()
                              .editMenu(
                                  name: menuNameController.text,
                                  isTaseRequired: isTaseRequired,
                                  id: widget.menu!.id.toString())
                              .then(
                            (value) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          await context
                              .read<MenuCubit>()
                              .addMenu(
                                menuName: menuNameController.text,
                                isTaseRequired: isTaseRequired,
                              )
                              .then(
                            (value) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    );
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
