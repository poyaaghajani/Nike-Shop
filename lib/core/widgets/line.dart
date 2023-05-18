import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';

class Line extends StatelessWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            LightThemeColors.purpule,
            LightThemeColors.navy,
            LightThemeColors.deepNavy,
            LightThemeColors.navy,
            LightThemeColors.purpule,
            Colors.white,
          ],
        ),
      ),
    );
  }
}
