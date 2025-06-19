import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/theme_cubit/theme_cubit.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/const/const_export.dart';

class ColorPickerScreen extends StatelessWidget {
  final List<Color> colorOptions = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,

    // MaterialAccent colors
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.indigoAccent,
    Colors.blueAccent,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.limeAccent,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
  ];

  ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Theme Color'),
        leading: AppBarLeading(onTap: () {
          Navigator.pop(context);
        }),
        leadingWidth: 75,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: context.watch<ThemeCubit>().state.isDarkMode
                  ? IconButton(
                      icon: Icon(Icons.wb_sunny),
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.nightlight_round),
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConst.kGlobalPadding + 20,
          vertical: SizeConst.kVerticalSpacing
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
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
      ),
    );
  }
}
