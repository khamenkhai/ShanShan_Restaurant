import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/model/response_models/menu_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

class MenuCRUDScreen extends StatefulWidget {
  const MenuCRUDScreen({super.key, required this.title});
  final String title;

  @override
  State<MenuCRUDScreen> createState() => _MenuCRUDScreenState();
}

class _MenuCRUDScreenState extends State<MenuCRUDScreen> {
  var menuNameController = TextEditingController();

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
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("မီနူး"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        label: Text("မီနူးအသစ်ထည့်ရန်"),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return MenuCRUDScreenDialog(
                screenSize: screenSize,
              );
            },
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
        child: _productListTest(
          screenSize,
        ),
      ),
    );
  }

  Widget _productListTest(Size screenSize) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is MenuLoadingState) {
          return loadingWidget();
        } else if (state is MenuLoadedState) {
          return GridView.builder(
            //controller: scrollController,
            
            padding: EdgeInsets.only(bottom: 20, top: 7.5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: SizeConst.kHorizontalPadding,
              crossAxisSpacing: SizeConst.kHorizontalPadding,
              childAspectRatio: screenSize.width * 0.002,
            ),
            itemCount: state.menuList.length,
            itemBuilder: (context, index) {
              MenuModel menu = state.menuList[index];
              return Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: SizeConst.kBorderRadius,
                ),
                child: menuCardWidget(
                  menu: menu,
                  onEdit: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MenuCRUDScreenDialog(
                          screenSize: screenSize,
                          menu: menu,
                        );
                      },
                    );
                  },
                  onDelete: () {
                    _deleteWarningDialog(
                      context: context,
                      screenSize: screenSize,
                      menuId: menu.id.toString(),
                    );
                  },
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  ///delete category warning dialog box
  Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String menuId,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: SizeConst.kBorderRadius,
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            width: screenSize.width / 3.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Text(
                  "ဖျက်ရန် သေချာလား",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 15),
                BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    if (state is MenuLoadingState) {
                      return loadingWidget();
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
                          custamizableElevated(
                            bgColor: Colors.red,
                            child: Text("ဖျက်မည်"),
                            onPressed: () async {
                              await context
                                  .read<MenuCubit>()
                                  .deleteMenu(
                                    id: menuId,
                                    //categoryName: menuNameController.text,
                                  )
                                  .then(
                                (value) {
                                  if (value) {
                                    Navigator.pop(context);
                                    context.read<MenuCubit>().getMenu();
                                  }
                                },
                              );
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
        );
      },
    );
  }
}

Widget menuCardWidget({
  required MenuModel menu,
  required Function() onEdit,
  required Function() onDelete,
}) {
  return Container(
    padding: EdgeInsets.only(
      top: SizeConst.kHorizontalPadding - 3,
      bottom: SizeConst.kHorizontalPadding - 3,
      left: 20,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              menu.name!.length > 20
                  ? "${menu.name}..".substring(0, 20)
                  : "${menu.name}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Spacer(),
            InkWell(
              onTap: onEdit,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Icon(
                  CupertinoIcons.delete,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ],
    ),
  );
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
        padding: EdgeInsets.all(20),
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
                        return loadingWidget();
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
                            custamizableElevated(
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
                                      if (value) {
                                        Navigator.pop(context);
                                        context.read<MenuCubit>().getMenu();
                                      }
                                    },
                                  );
                                } else {
                                  await context
                                      .read<MenuCubit>()
                                      .addMenu(
                                          menuName: menuNameController.text,
                                          isTaseRequired: isTaseRequired)
                                      .then(
                                    (value) {
                                      if (value) {
                                        Navigator.pop(context);
                                        context.read<MenuCubit>().getMenu();
                                      }
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
