import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_state.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/models/data_models/spicy_level.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/core/component/custom_dialog.dart';

////spicy levvel crud dialob box
class SpicyLevelCRUDDialog extends StatefulWidget {
  const SpicyLevelCRUDDialog({
    super.key,
    required this.screenSize,
    this.spicyLevel,
  });

  final Size screenSize;

  final SpicyLevelModel? spicyLevel;

  @override
  State<SpicyLevelCRUDDialog> createState() => _SpicyLevelCRUDDialogState();
}

class _SpicyLevelCRUDDialogState extends State<SpicyLevelCRUDDialog> {
  final TextEditingController spicyLevelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.spicyLevel != null) {
      spicyLevelController.text = widget.spicyLevel!.name.toString();
      descriptionController.text = widget.spicyLevel!.description.toString();
      positionController.text = widget.spicyLevel!.position.toString();
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      paddingInVertical: false,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                tr(LocaleKeys.spicyLevel),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 10),
              TextFormField(
                controller: spicyLevelController,
                validator: (value) {
                  if (value == "") {
                    return "Spicy Level can't be empty";
                  }
                  return null;
                },
                decoration: customTextDecoration2(
                  labelText: "အစပ် Level ကိုtr(LocaleKeys.confirm)",
                    primaryColor: Theme.of(context).primaryColor
                ),
              ),

              ///position
              SizedBox(height: 15),
              Text(
                tr(LocaleKeys.position),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
                builder: (context, state) {
                  if (state is SpicyLevelLoaded) {
                    List<int> spicyLevels = [];
                    for (var e in state.spicyLevels) {
                      spicyLevels.add(e.position ?? 0);
                    }
                    return TextFormField(
                      controller: positionController,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "လိုအပ်သည်!";
                        } else if (spicyLevels.contains(
                              int.parse(value),
                            ) &&
                            widget.spicyLevel == null) {
                          return "နေရာနံပါတ် ရှိပြီးသားပါ။";
                        } else {
                          return null;
                        }
                      },
                      decoration: customTextDecoration2(
                        labelText: "",  primaryColor: Theme.of(context).primaryColor
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 15),

              ///description

              Text(
                tr(LocaleKeys.description),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: customTextDecoration2(
                  labelText: "",  primaryColor: Theme.of(context).primaryColor
                ),
              ),
              SizedBox(height: 15),

              BlocConsumer<SpicyLevelCubit, SpicyLevelCrudState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is SpicyLevelLoading) {
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
                          child: Text(tr(LocaleKeys.confirm)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.spicyLevel != null) {
                                await editSpicLevelData(context);
                              } else {
                                await addNewSpicyLevel(context);
                              }
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  ///add new spicy level data
  Future<void> addNewSpicyLevel(BuildContext context) async {
    await context.read<SpicyLevelCubit>().addNewSpicy(
        levelName: spicyLevelController.text,
        description: descriptionController.text,
        position: int.parse(positionController.text));
  }

  ///edit spicy level data
  Future<void> editSpicLevelData(BuildContext context) async {
    await context.read<SpicyLevelCubit>().editSpicyLevel(
        name: spicyLevelController.text,
        description: descriptionController.text,
        id: widget.spicyLevel!.id.toString(),
        position: int.parse(positionController.text));
  }
}
