import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_state.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/const/size_const.dart';
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/ahtone_level_crud_dialog.dart';
import 'package:shan_shan/view/widgets/control_panel_widgets/common_crud_card.dart';

class AhtoneLevelScreen extends StatefulWidget {
  const AhtoneLevelScreen({super.key, required this.title});
  final String title;

  @override
  State<AhtoneLevelScreen> createState() => _AhtoneLevelScreenState();
}

class _AhtoneLevelScreenState extends State<AhtoneLevelScreen> {
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
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("${widget.title}"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstants.primaryColor,
        label: Text("အထုံ Level အသစ်ထည့်ရန်"),
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
              EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
          child: _productListTest(screenSize),
        ),
        onRefresh: () {
          context.read<HtoneLevelCubit>().getAllLevels();
        },
      ),
    );
  }

  Widget _productListTest(Size screenSize) {
    return BlocBuilder<HtoneLevelCubit, AhtoneLevelCrudState>(
      builder: (context, state) {
        if (state is AhtoneLevelLoading) {
          return loadingWidget();
        } else if (state is AhtoneLevelLoaded) {
          return GridView.builder(
            
            padding: EdgeInsets.only(bottom: 20, top: 7.5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: SizeConst.kHorizontalPadding,
              crossAxisSpacing: SizeConst.kHorizontalPadding,
              childAspectRatio: screenSize.width * 0.002,
            ),
            itemCount: state.ahtone_level.length,
            itemBuilder: (context, index) {
              AhtoneLevelModel ahtoneLevel = state.ahtone_level[index];
              return Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: SizeConst.kBorderRadius,
                ),
                child: commonCrudCard(
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
                      ahtone_level_id: ahtoneLevel.id.toString(),
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
  Future<dynamic> _deleteWarningDialog(
      {required BuildContext context,
      required Size screenSize,
      required String ahtone_level_id}) {
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
                BlocBuilder<HtoneLevelCubit, AhtoneLevelCrudState>(
                  builder: (context, state) {
                    if (state is AhtoneLevelLoading) {
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
                              await _deleteAhtoneLevelData(
                                context: context,
                                ahtone_level_id: ahtone_level_id,
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
    required String ahtone_level_id,
  }) async {
    await context
        .read<HtoneLevelCubit>()
        .deleteAhtoneLevel(id: ahtone_level_id);
  }
}
