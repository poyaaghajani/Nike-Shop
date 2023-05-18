import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/line.dart';
import 'package:nike/features/auth_feature/data/repository/auth_repository.dart';
import 'package:nike/features/auth_feature/presentation/screen/auth_screen.dart';
import 'package:nike/features/profile_feature/presentation/screen/favorite_screen.dart';
import 'package:nike/features/profile_feature/presentation/screen/order_record_screen.dart';
import 'package:nike/features/profile_feature/presentation/widgets/logout_dialog.dart';
import 'package:nike/features/profile_feature/presentation/widgets/profile_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder(
          valueListenable: AuthRepository.authChangeNotifire,
          builder: (context, value, child) {
            final isLogedIn = value != null && value.accessToken.isNotEmpty;
            return Center(
              child: Padding(
                padding:
                    EdgeInsets.only(top: DeviseSize.getHeight(context) / 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 95,
                      width: 95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: LightThemeColors.deepNavy),
                      ),
                      child: FittedBox(
                        child: Image.asset(
                          'assets/images/nike_logo.png',
                        ),
                      ),
                    ),
                    SizedBox(height: DeviseSize.getHeight(context) / 85),
                    Text(isLogedIn ? value.email : 'کاربر میهمان'),
                    SizedBox(height: DeviseSize.getHeight(context) / 60),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Line(),
                    ),
                    ProfileItem(
                      icon: CupertinoIcons.heart,
                      text: 'لیست علاقه مندی ها',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return FavoriteScreen();
                            },
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Line(),
                    ),
                    ProfileItem(
                      icon: CupertinoIcons.cart_badge_plus,
                      text: 'سوابق سفارش',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const OrderRecordScreen();
                            },
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Line(),
                    ),
                    ProfileItem(
                      icon: isLogedIn ? Icons.login : Icons.exit_to_app,
                      text: isLogedIn
                          ? 'خروج از حساب کاربری'
                          : 'ورود به حساب کاربری',
                      onTap: () {
                        isLogedIn
                            ? LogoutDialog.showLogoutDialog(context)
                            : Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AuthScreen();
                                  },
                                ),
                              );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Line(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
