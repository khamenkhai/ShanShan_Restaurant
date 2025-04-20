import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_state.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/view/control_panel/widgets/common_crud_card.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:shan_shan/view/control_panel/widgets/spicy_level_crud_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SpicyLevelScreen extends StatefulWidget {
  const SpicyLevelScreen({super.key});

  @override
  State<SpicyLevelScreen> createState() => _SpicyLevelScreenState();
}

class _SpicyLevelScreenState extends State<SpicyLevelScreen> {
  var spicyLevelController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    context.read<SpicyLevelCubit>().getAllLevels();
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
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("အစပ် Level"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        label: Text("အစပ်Levelအသစ်ထည့်ရန်"),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SpicyLevelCRUDDialog(screenSize: screenSize);
            },
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConst.kHorizontalPadding,
        ),
        child: mainForm(screenSize),
      ),
    );
  }

  ///main form widget of spicy level
  Widget mainForm(Size screenSize) {
    return BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
      builder: (context, state) {
        if (state is SpicyLevelLoading) {
          return Skeletonizer(
            enabled: true,
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: 20, top: 7.5),
              gridDelegate: _gridDelegate(screenSize),
              itemCount: 5,
              itemBuilder: (context, index) {
                return CrudCard(title: "Hello world");
              },
            ),
          );
        } else if (state is SpicyLevelLoaded) {
          return GridView.builder(
            padding: EdgeInsets.only(bottom: 20, top: 7.5),
            gridDelegate: _gridDelegate(screenSize),
            itemCount: state.spicyLevels.length,
            itemBuilder: (context, index) {
              SpicyLevelModel spicyLevel = state.spicyLevels[index];
              return CrudCard(
                title: spicyLevel.name ?? "",
                description: spicyLevel.description ?? "",
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SpicyLevelCRUDDialog(
                        screenSize: screenSize,
                        spicyLevel: spicyLevel,
                      );
                    },
                  );
                },
                onDelete: () {
                  _deleteWarningDialog(
                    context: context,
                    screenSize: screenSize,
                    id: spicyLevel.id.toString(),
                  );
                },
              );
            },
          );
        } else {
          return Container();
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

  ///delete  warning dialog box
  Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String id,
  }) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
        builder: (context, state) {
          if (state is SpicyLevelLoading) {
            return LoadingWidget();
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomOutlineButton(
                  elevation: 0,
                  child: Text("ပယ်ဖျက်ရန်"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10),
                CustomElevatedButton(
                  bgColor: Colors.red,
                  child: Text("ဖျက်မည်"),
                  onPressed: () async {
                    await deleteSpicyLevelData(context, id);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  ///delete spicy level data
  Future<void> deleteSpicyLevelData(
    BuildContext context,
    String id,
  ) async {
    await context.read<SpicyLevelCubit>().deleteSpicyLevel(
          id: id,
        );
  }
}
