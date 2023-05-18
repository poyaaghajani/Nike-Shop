import 'package:flutter/cupertino.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/devise_size.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: LightThemeColors.deepNavy,
            ),
            SizedBox(width: DeviseSize.getWidth(context) / 85),
            Text(text),
          ],
        ),
      ),
    );
  }
}
