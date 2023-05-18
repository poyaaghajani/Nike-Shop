import 'package:flutter/cupertino.dart';
import 'package:nike/config/light_color.dart';

class BasketCount extends StatelessWidget {
  const BasketCount({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23,
      height: 23,
      decoration: BoxDecoration(
        border: Border.all(
          color: LightThemeColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        icon,
        size: 15,
        color: LightThemeColors.primaryColor,
      ),
    );
  }
}
