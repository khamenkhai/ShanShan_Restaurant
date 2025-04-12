import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/theme_cubit/theme_cubit.dart';

class ColorPickerScreen extends StatelessWidget {
  final List<Color> colorOptions = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    // Add more colors as needed
  ];

  ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Theme Color'),
        actions: [
          Switch(
            value: context.watch<ThemeCubit>().state.isDarkMode,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme();
            },
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: colorOptions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context
                  .read<ThemeCubit>()
                  .changePrimaryColor(colorOptions[index]);
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: colorOptions[index],
              radius: 15,
            ),
          );
        },
      ),
    );
  }
}
