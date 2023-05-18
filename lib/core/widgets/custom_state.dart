import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike/config/light_color.dart';

class CustomState extends StatelessWidget {
  const CustomState({
    super.key,
    required this.text,
    required this.image,
    required this.onTap,
    required this.buttonText,
    this.bgColor = LightThemeColors.deepNavy,
  });

  final String text;
  final String image;
  final void Function()? onTap;
  final String buttonText;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            height: 270,
          ),
          const SizedBox(height: 15),
          Text(text),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
