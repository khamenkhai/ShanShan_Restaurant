import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/model/response_models/category_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/common_crud_card.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/delete_warning_dialog.dart';

class CategoryCRUDScreen extends StatefulWidget {
  const CategoryCRUDScreen({super.key, required this.title});
  final String title;

  @override
  State<CategoryCRUDScreen> createState() => _CategoryCRUDScreenState();
}

class _CategoryCRUDScreenState extends State<CategoryCRUDScreen> {
  var categoryNameController = TextEditingController();
  var productPriceController = TextEditingController();

  @override
  void initState() {
    context.read<CategoryCubit>().getAllCategories();
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
        title: Text("${widget.title}"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        label: Text("အသစ်ထည့်ရန်"),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return CategoryCRUDScreenDialog(
                screenSize: screenSize,
              );
            },
          );
        },
      ),
      body: InternetCheckWidget(
        onRefresh: () {
          context.read<CategoryCubit>().getAllCategories();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConst.kHorizontalPadding,
          ),
          child: _productListTest(screenSize),
        ),
      ),
    );
  }

  Widget _productListTest(Size screenSize) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return loadingWidget();
        } else if (state is CategoryLoadedState) {
          return state.categoryList.length > 0
              ? GridView.builder(
                  
                  padding: EdgeInsets.only(bottom: 20, top: 7.5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: SizeConst.kHorizontalPadding,
                    crossAxisSpacing: SizeConst.kHorizontalPadding,
                    childAspectRatio: screenSize.width * 0.002,
                  ),
                  itemCount: state.categoryList.length,
                  itemBuilder: (context, index) {
                    CategoryModel category = state.categoryList[index];
                    return Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: SizeConst.kBorderRadius,
                      ),
                      child: commonCrudCard(
                        title: category.name.toString(),
                        description: category.description.toString(),
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CategoryCRUDScreenDialog(
                                screenSize: screenSize,
                                category: category,
                              );
                            },
                          );
                        },
                        onDelete: () {
                          _deleteWarningDialog(
                            context: context,
                            screenSize: screenSize,
                            categoryId: category.id.toString(),
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No Categories Here!",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
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
    required String categoryId,
  }) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return loadingWidget();
          } else {
            return CancelAndDeleteDialogButton(
              onDelete: () async {
                await deleteCategoryData(context, categoryId);
              },
            );
          }
        },
      ),
    );
  }

  ///delete category
  Future<void> deleteCategoryData(
    BuildContext context,
    String categoryId,
  ) async {
    await context.read<CategoryCubit>().deleteCategory(id: categoryId);
  }
}

////category crud dialob box
class CategoryCRUDScreenDialog extends StatefulWidget {
  const CategoryCRUDScreenDialog({
    super.key,
    required this.screenSize,
    this.category,
  });

  final Size screenSize;

  final CategoryModel? category;

  @override
  State<CategoryCRUDScreenDialog> createState() =>
      _CategoryCRUDScreenDialogState();
}

class _CategoryCRUDScreenDialogState extends State<CategoryCRUDScreenDialog> {
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  @override
  void initState() {
    if (widget.category != null) {
      categoryNameController.text = widget.category!.name.toString();
    }
    setState(() {});
    super.initState();
  }

  bool isGram = false;

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
                  ///category name
                  Text(
                    "အမျိုးအစား",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: categoryNameController,
                    validator: (value) {
                      if (value == "") {
                        return "Category Name can't be empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "အမျိုးအစားအမည်အသစ်ရေးရန်",
                    ),
                  ),

                  SizedBox(height: 15),

                  BlocConsumer<CategoryCubit, CategoryState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is CategoryLoadingState) {
                        return loadingWidget();
                      } else {
                        return CancelAndConfirmDialogButton(
                          onConfirm: () async {
                            if (widget.category != null) {
                              await updateCategory(context);
                            } else {
                              await createNewCategory(context);
                            }
                          },
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

  ///crate category
  Future<void> createNewCategory(BuildContext context) async {
    await context
        .read<CategoryCubit>()
        .createCategory(name: categoryNameController.text, description: "");
  }

  ///update category data
  Future<void> updateCategory(BuildContext context) async {
    await context.read<CategoryCubit>().updateCategory(
        name: categoryNameController.text,
        description: "",
        id: widget.category!.id.toString());
  }
}
