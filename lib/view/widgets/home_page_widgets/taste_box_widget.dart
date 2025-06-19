import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_state.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_state.dart';
import 'package:shan_shan/core/component/select.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/context_extension.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/models/response_models/cart_item_model.dart';

class TasteBoxWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final CartItem? defaultItem;
  final bool isEditState;

  const TasteBoxWidget(
      {super.key,
      required this.constraints,
      this.defaultItem,
      required this.isEditState});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        borderRadius: SizeConst.kBorderRadius,
        color: Theme.of(context).cardColor,
        child: Container(
          width: ((constraints.maxWidth - SizeConst.kGlobalPadding) / 2),
          decoration: BoxDecoration(
            borderRadius: SizeConst.kBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConst.kGlobalPadding,
                  vertical: SizeConst.kGlobalPadding / 2,
                ),
                child: Row(
                  children: [
                    Text(
                      "🌶️",
                      style: context.subTitle(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Tastes",
                      style: context.subTitle(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: SizeConst.kGlobalPadding,
                    left: SizeConst.kGlobalPadding,
                    top: 8,
                    bottom: SizeConst.kGlobalPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
                        builder: (context, state) {
                          if (state is SpicyLevelLoaded) {
                            return ShadcnSelect(
                              labelText: "Spicy Level",
                              value: context
                                      .watch<CartCubit>()
                                      .state
                                      .spicyLevel
                                      ?.name ??
                                  "Select spicy level",
                              items: state.spicyLevels
                                  .map((sl) => sl.toJson())
                                  .toList(),
                              hintText: 'Select a spicy level',
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<CartCubit>().addData(
                                      spicyLevel:
                                          SpicyLevelModel.fromMap(value));
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<HtoneLevelCubit, HtoneLevelState>(
                        builder: (context, state) {
                          if (state is HtoneLevelLoaded) {
                            return ShadcnSelect(
                              labelText: "Htone Level",
                              value: context
                                      .watch<CartCubit>()
                                      .state
                                      .athoneLevel
                                      ?.name ??
                                  "Select htone level",
                              items: state.htoneLevels
                                  .map((sl) => sl.toJson())
                                  .toList(),
                              hintText: 'Select htone level',
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<CartCubit>().addData(
                                      htoneLevel:
                                          AhtoneLevelModel.fromMap(value));
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
