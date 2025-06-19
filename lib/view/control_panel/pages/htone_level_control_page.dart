import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_state.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/ahtone_level_crud_dialog.dart';
import 'package:shan_shan/view/control_panel/widgets/common_crud_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HtoneLevelControlPage extends StatefulWidget {
  const HtoneLevelControlPage({super.key});

  @override
  State<HtoneLevelControlPage> createState() => _HtoneLevelControlPageState();
}

class _HtoneLevelControlPageState extends State<HtoneLevelControlPage> {
  var ahtoneLevelController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  void initState() {
    context.read<HtoneLevelCubit>().getAllLevels();
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
        title: Text(tr(LocaleKeys.htoneLevel)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(tr(LocaleKeys.addNewHtoneLevel)),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AhtoneLevelCRUDDialog(screenSize: screenSize);
            },
          );
        },
      ),
      body: InternetCheckWidget(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConst.kGlobalPadding),
          child: _productListTest(screenSize),
        ),
        onRefresh: () {
          context.read<HtoneLevelCubit>().getAllLevels();
        },
      ),
    );
  }

  Widget _productListTest(Size screenSize) {
    return BlocBuilder<HtoneLevelCubit, HtoneLevelState>(
      builder: (context, state) {
        if (state is AhtoneLevelLoading) {
          return Skeletonizer(
            enabled: true,
            child: GridView.builder(
              gridDelegate: _gridDelegate(screenSize),
              itemCount: 5,
              itemBuilder: (context,index){
                return CrudCard(title: "Hello world");
              },
            ),
          );
        } else if (state is HtoneLevelLoaded) {
          return GridView.builder(
            padding: EdgeInsets.only(bottom: 20, top: 7.5),
            gridDelegate: _gridDelegate(screenSize),
            itemCount: state.htoneLevels.length,
            itemBuilder: (context, index) {
              AhtoneLevelModel ahtoneLevel = state.htoneLevels[index];
              return CrudCard(
                title: ahtoneLevel.name ?? "",
                description: ahtoneLevel.description ?? "",
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AhtoneLevelCRUDDialog(
                        screenSize: screenSize,
                        ahtoneLevel: ahtoneLevel,
                      );
                    },
                  );
                },
                onDelete: () {
                  _deleteWarningDialog(
                    context: context,
                    screenSize: screenSize,
                    id: ahtoneLevel.id.toString(),
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
      mainAxisSpacing: SizeConst.kGlobalPadding,
      crossAxisSpacing: SizeConst.kGlobalPadding,
      childAspectRatio: screenSize.width * 0.002,
    );
  }

  ///delete category warning dialog box
  Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String id,
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
                  tr(LocaleKeys.deletePrompt),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 15),
                BlocBuilder<HtoneLevelCubit, HtoneLevelState>(
                  builder: (context, state) {
                    if (state is AhtoneLevelLoading) {
                      return LoadingWidget();
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomOutlineButton(
                            elevation: 0,
                            child: Text(tr(LocaleKeys.cancel)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 10),
                          CustomElevatedButton(
                            bgColor: Colors.red,
                            child:  Text(tr(LocaleKeys.delete)),
                            onPressed: () async {
                              await _deleteAhtoneLevelData(
                                context: context,
                                id: id,
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

  ///delete ahtone level data
  Future<void> _deleteAhtoneLevelData({
    required BuildContext context,
    required String id,
  }) async {
    Navigator.pop(context);
    await context.read<HtoneLevelCubit>().deleteAhtoneLevel(id: id);
  }
}
