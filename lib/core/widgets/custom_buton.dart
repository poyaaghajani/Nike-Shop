import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final Color color;
  final double? radius;
  final double? height;
  final double? width;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
    this.radius,
    this.height,
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width ?? 30, height ?? 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 6),
        ),
      ),
      child: Text(
        text ?? '',
        style: textStyle,
      ),
    );
  }
}
