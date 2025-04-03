import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/models/response_models/menu_model.dart';
import 'package:shan_shan/view/control_panel/widgets/common_crud_card.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MenuCRUDScreen extends StatefulWidget {
  const MenuCRUDScreen({super.key, required this.title});
  final String title;

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
        leading: appBarLeading(
          onTap: () => Navigator.pop(context),
        ),
        title: const Text("မီနူး"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        label: const Text("မီနူးအသစ်ထည့်ရန်"),
        icon: const Icon(Icons.add),
        onPressed: () => _showMenuDialog(screenSize),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
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
      mainAxisSpacing: SizeConst.kHorizontalPadding,
      crossAxisSpacing: SizeConst.kHorizontalPadding,
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
                      customizableOTButton(
                        elevation: 0,
                        child: const Text("ပယ်ဖျက်ရန်"),
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
      isTaseRequired = widget.menu!.is_fish ?? false;
    }
    setState(() {});
    super.initState();
  }

  bool isTaseRequired = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: SizeConst.kBorderRadius,
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(15),
        width: widget.screenSize.width / 3.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              padding: EdgeInsets.all(SizeConst.kHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///menu name
                  Text(
                    "မီနူးအမည်",
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
                      labelText: "မီနူးအမည်အသစ်ထည့်ရန်",
                    ),
                  ),

                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isTaseRequired = !isTaseRequired;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          isTaseRequired
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isTaseRequired
                              ? ColorConstants.primaryColor
                              : Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text("အထုံ/အစပ် မရွေးပါ")
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            customizableOTButton(
                              elevation: 0,
                              child: Text("ပယ်ဖျက်ရန်"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(width: 10),
                            CustomElevatedButton(
                              child: Text("အတည်ပြုရန်"),
                              onPressed: () async {
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
                            ),
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
