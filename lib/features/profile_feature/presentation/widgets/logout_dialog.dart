import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/features/auth_feature/data/repository/auth_repository.dart';
import 'package:nike/features/auth_feature/presentation/screen/auth_screen.dart';

class LogoutDialog {
  static showLogoutDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: LightThemeColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'از خروج حساب کاربری خود مطمعن هستید؟',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.green),
                  onPressed: () {
                    Navigator.pop(context);
                    authRepository.logOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const AuthScreen();
                        },
                      ),
                    );
                  },
                  child: const Text('بله'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('خیر'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
