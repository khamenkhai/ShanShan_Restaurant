import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_state.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/custom_outline_button.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:shan_shan/view/common_widgets/custom_dialog.dart';

class AhtoneLevelCRUDDialog extends StatefulWidget {
  const AhtoneLevelCRUDDialog({
    super.key,
    required this.screenSize,
    this.ahtoneLevel,
  });

  final Size screenSize;
  final AhtoneLevelModel? ahtoneLevel;

  @override
  State<AhtoneLevelCRUDDialog> createState() => _AhtoneLevelCRUDDialogState();
}

class _AhtoneLevelCRUDDialogState extends State<AhtoneLevelCRUDDialog> {
  final TextEditingController ahtoneLevelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.ahtoneLevel != null) {
      ahtoneLevelController.text = widget.ahtoneLevel!.name ?? "";
      descriptionController.text = widget.ahtoneLevel!.description ?? "";
      positionController.text = widget.ahtoneLevel!.position.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      paddingInVertical: false,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              _buildLabel("အထုံ Level"),
              _buildTextField(ahtoneLevelController, "အထုံ Level အသစ်ထည့်ရန်"),
              const SizedBox(height: 20),
              _buildLabel("နေရာ"),
              _buildPositionField(),
              const SizedBox(height: 20),
              _buildLabel("ဖော်ပြချက်"),
              _buildTextField(descriptionController, ""),
              const SizedBox(height: 15),
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a label with given text
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }

  /// Builds a text field with given controller and label
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      validator: (value) => value == "" ? "လိုအပ်သည်" : null,
      decoration: customTextDecoration2(labelText: label),
    );
  }

  /// Builds the position text field with validation
  Widget _buildPositionField() {
    return BlocBuilder<HtoneLevelCubit, AhtoneLevelCrudState>(
      builder: (context, state) {
        if (state is AhtoneLevelLoaded) {
          List<int> positions = state.htoneLevels.map((e) => e.position ?? 0).toList();
          return TextFormField(
            controller: positionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "လိုအပ်သည်";
              } else if (positions.contains(int.parse(value)) && widget.ahtoneLevel == null) {
                return "နေရာနံပါတ် ရှိပြီးသားပါ။";
              }
              return null;
            },
            decoration: customTextDecoration2(labelText: "နေရာ"),
          );
        }
        return Container();
      },
    );
  }

  /// Builds the action buttons row
  Widget _buildActionButtons() {
    return BlocConsumer<HtoneLevelCubit, AhtoneLevelCrudState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AhtoneLevelLoading) {
          return const LoadingWidget();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomOutlineButton(
              elevation: 0,
              child: const Text("ပယ်ဖျက်ရန်"),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            CustomElevatedButton(
              child: const Text("အတည်ပြုရန်"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.ahtoneLevel != null ? _editAhtoneLevel() : _createAhtoneLevel();
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Handles editing of Ahtone Level
  Future<void> _editAhtoneLevel() async {
    await context.read<HtoneLevelCubit>().editAhtoneLevel(
          name: ahtoneLevelController.text,
          description: descriptionController.text,
          id: widget.ahtoneLevel!.id.toString(),
          position: int.parse(positionController.text),
        );
    if (!mounted) return;
    Navigator.pop(context);
  }

  /// Handles creation of new Ahtone Level
  Future<void> _createAhtoneLevel() async {
    await context.read<HtoneLevelCubit>().addNewAhtone(
          levelName: ahtoneLevelController.text,
          description: descriptionController.text,
          position: int.parse(positionController.text),
        );
    if (!mounted) return;
    Navigator.pop(context);
  }
}