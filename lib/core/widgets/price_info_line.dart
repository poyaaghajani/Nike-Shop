import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/devise_size.dart';

class PriceInfoLine extends StatelessWidget {
  const PriceInfoLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: DeviseSize.getWidth(context),
      height: 0.5,
      decoration: const BoxDecoration(
        color: LightThemeColors.deepNavy,
      ),
    );
  }
}
