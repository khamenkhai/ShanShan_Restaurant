import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/theme_cubit/theme_cubit.dart';

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
        actions: [
          Switch(
            value: context.watch<ThemeCubit>().state.isDarkMode,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
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
                radius: 20,
              ),
            );
          },
        ),
      ),
    );
  }
}
