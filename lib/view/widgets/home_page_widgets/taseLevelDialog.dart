// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_state.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_state.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';
import 'package:shan_shan/model/data_models/spicy_level.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/common_widgets/custom_dialog.dart';

class TasteChooseDialog extends StatefulWidget {
  const TasteChooseDialog({super.key});

  @override
  State<TasteChooseDialog> createState() => _TasteChooseDialogState();
}

class _TasteChooseDialogState extends State<TasteChooseDialog> {
  String selectedSpicyLevel = "";
  String selectedAthoneLevel = "";

  List<SpicyLevelModel> spicyLevels = [];
  List<AhtoneLevelModel> athoneLevels = [];

  String errorText = "";

  @override
  Widget build(BuildContext context) {
    var dialogWidth = MediaQuery.of(context).size.width / 3;
    return CustomDialog(
      width: dialogWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ahtoneLevelColumn(width: dialogWidth / 2.5),
                spicyLevelColumn(width: dialogWidth / 2.5),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "$errorText",
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customizableOTButton(
                  child: Text("ပယ်ဖျက်ရန်"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10),
                CustomElevatedButton(
                  child: Text("ထည့်ရန်"),
                  onPressed: () {
                    addTasteLevels();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///ahtone level column
  Column ahtoneLevelColumn({required double width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "အထုံ Level",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<HtoneLevelCubit, AhtoneLevelCrudState>(
          builder: (context, state) {
            if (state is AhtoneLevelLoaded) {
              athoneLevels = state.ahtone_level;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...state.ahtone_level
                      .map(
                        (e) => _athoneLevelRadio(
                          value: e,
                          width: width,
                        ),
                      )
            ,
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  ///spicy level column
  Column spicyLevelColumn({required double width}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "အစပ် Level",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
          builder: (context, state) {
            if (state is SpicyLevelLoaded) {
              spicyLevels = state.spicy_level;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...state.spicy_level
                      .map((e) => _spicyLevelRadio(value: e, width: width))
                      
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  ///spicy level radio
  Widget _spicyLevelRadio({
    required SpicyLevelModel value,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: RadioListTile(
        contentPadding: EdgeInsets.zero,
        value: "${value.id}",
        groupValue: selectedSpicyLevel,
        title: Text("${value.name}"),
        onChanged: (value) {
          setState(() {
            selectedSpicyLevel = value!;
          });
          customPrint("athone : $selectedSpicyLevel");
        },
      ),
    );
  }

  ///athone level radio
  Widget _athoneLevelRadio({
    required AhtoneLevelModel value,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: RadioListTile(
        contentPadding: EdgeInsets.zero,
        value: "${value.id}",
        title: Text("${value.name}"),
        groupValue: selectedAthoneLevel,
        onChanged: (value) {
          setState(() {
            selectedAthoneLevel = value!;
          });
          customPrint("athone : $selectedAthoneLevel");
        },
      ),
    );
  }

  ///get selected ahtone level
  AhtoneLevelModel getSelectedAhtoneLevel(List<AhtoneLevelModel> list) {
    try {
      return list.firstWhere(
          (element) => element.id.toString() == selectedAthoneLevel);
    } catch (e) {
      throw Exception();
    }
  }

  ///get selected ahtone level
  SpicyLevelModel getSelectedSpicyLevel(List<SpicyLevelModel> list) {
    try {
      return list
          .firstWhere((element) => element.id.toString() == selectedSpicyLevel);
    } catch (e) {
      throw Exception();
    }
  }

  ///add taste
  void addTasteLevels() {
    if (selectedAthoneLevel == "" && selectedSpicyLevel != "") {
      errorText = "အထုံ Level ရွေးရန် လိုအပ်ပါသည်";
    } else if (selectedAthoneLevel != "" && selectedSpicyLevel == "") {
      errorText = "အစပ် Level ရွေးရန် လိုအပ်ပါသည်";
    } else if (selectedAthoneLevel == "" && selectedSpicyLevel == "") {
      errorText = "အထုံ Level နှင့် အစပ် Level ရွေးရန် လိုအပ်ပါသည်";
    } else {
      errorText = "";
      try {
        Navigator.pop(context, {
          'spicyLevel': getSelectedSpicyLevel(spicyLevels),
          'athoneLevel': getSelectedAhtoneLevel(athoneLevels),
        });
      } catch (e) {
        customPrint("error : $e");
      }
    }

    setState(() {});
  }
}
