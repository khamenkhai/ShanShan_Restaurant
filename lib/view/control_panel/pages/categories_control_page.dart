import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/models/response_models/category_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';
import 'package:shan_shan/view/control_panel/widgets/common_crud_card.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/delete_warning_dialog.dart';

class CategoriesControlPage extends StatefulWidget {
  const CategoriesControlPage({super.key, required this.title});
  final String title;

  @override
  State<CategoriesControlPage> createState() => _CategoriesControlPageState();
}

class _CategoriesControlPageState extends State<CategoriesControlPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        centerTitle: true,
        leading: appBarLeading(onTap: () => Navigator.pop(context)),
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        label: const Text("အသစ်ထည့်ရန်"),
        icon: const Icon(Icons.add),
        onPressed: () => _showCategoryDialog(context, screenSize),
      ),
      body: InternetCheckWidget(
        onRefresh: () => context.read<CategoryCubit>().getAllCategories(),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
          child: _categoryList(screenSize),
        ),
      ),
    );
  }

  Widget _categoryList(Size screenSize) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return _skeletonLoader(screenSize);
        } else if (state is CategoryLoadedState &&
            state.categoryList.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 20, top: 7.5),
            gridDelegate: _sliverGridDelegate(screenSize),
            itemCount: state.categoryList.length,
            itemBuilder: (context, index) {
              final category = state.categoryList[index];
              return CrudCard(
                title: category.name.toString(),
                description: category.description.toString(),
                onEdit: () => _showCategoryDialog(
                  context,
                  screenSize,
                  category: category,
                ),
                onDelete: () => _deleteWarningDialog(
                  screenSize,
                  category.id.toString(),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "No Categories Here!",
              style: TextStyle(fontSize: 25),
            ),
          );
        }
      },
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _sliverGridDelegate(
      Size screenSize) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: SizeConst.kHorizontalPadding,
      crossAxisSpacing: SizeConst.kHorizontalPadding,
      childAspectRatio: screenSize.width * 0.002,
    );
  }

  Widget _skeletonLoader(Size screenSize) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 20, top: 7.5),
        gridDelegate: _sliverGridDelegate(screenSize),
        itemCount: 8,
        itemBuilder: (context, index) {
          return CrudCard(title: "Hello World");
        },
      ),
    );
  }

  Future<void> _deleteWarningDialog(
    Size screenSize,
    String categoryId,
  ) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: CancelAndDeleteDialogButton(onDelete: () {
        Navigator.pop(context);
        context.read<CategoryCubit>().deleteCategory(id: categoryId);
      }),
    );
  }

  void _showCategoryDialog(
    BuildContext context,
    Size screenSize, {
    CategoryModel? category,
  }) {
    showDialog(
      context: context,
      builder: (context) => CategoriesControlPageDialog(
        screenSize: screenSize,
        category: category,
      ),
    );
  }
}

class CategoriesControlPageDialog extends StatefulWidget {
  const CategoriesControlPageDialog({
    super.key,
    required this.screenSize,
    this.category,
  });

  final Size screenSize;
  final CategoryModel? category;

  @override
  State<CategoriesControlPageDialog> createState() =>
      _CategoriesControlPageDialogState();
}

class _CategoriesControlPageDialogState
    extends State<CategoriesControlPageDialog> {
  final TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      categoryNameController.text = widget.category!.name.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: SizeConst.kBorderRadius),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("အမျိုးအစား", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextFormField(
                controller: categoryNameController,
                decoration: customTextDecoration2(
                    labelText: "အမျိုးအစားအမည်အသစ်ရေးရန်"),
              ),
              const SizedBox(height: 15),
              BlocConsumer<CategoryCubit, CategoryState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is CategoryLoadingState) {
                    return LoadingWidget();
                  } else {
                    return CancelAndConfirmDialogButton(
                      onConfirm: () => widget.category != null
                          ? _updateCategory()
                          : _createNewCategory(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createNewCategory() async {
    await context
        .read<CategoryCubit>()
        .createCategory(name: categoryNameController.text, description: "")
        .then((v) {
      popContext();
    });
  }

  Future<void> _updateCategory() async {
    await context
        .read<CategoryCubit>()
        .updateCategory(
          name: categoryNameController.text,
          description: "",
          id: widget.category!.id.toString(),
        )
        .then((v) {
      popContext();
    });
  }

  void popContext() {
    if (!context.mounted) return;
    Navigator.pop(context);
  }
}
