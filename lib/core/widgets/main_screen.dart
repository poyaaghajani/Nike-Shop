import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/features/basket_feature/data/repository/basket_repository.dart';
import 'package:nike/features/basket_feature/presentation/screens/basket_screen.dart';
import 'package:nike/features/basket_feature/presentation/widgets/badges.dart';
import 'package:nike/features/home_feature/presentation/screens/home_screen.dart';
import 'package:nike/features/profile_feature/presentation/screen/profile_screen.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey,
  };

  Future<bool> onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }

    return true;
  }

  @override
  void initState() {
    basketRepository.getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: selectedScreenIndex,
          children: [
            navigator(_homeKey, homeIndex, const HomeScreen()),
            navigator(_cartKey, cartIndex, const BasketScreen()),
            navigator(_profileKey, profileIndex, const ProfileScreen()),
          ],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 15, left: 12, right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: LightThemeColors.deepNavy.withOpacity(0.9),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            unselectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedItemColor: Colors.white,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(CupertinoIcons.cart),
                      Positioned(
                        right: -10,
                        top: -5,
                        child: ValueListenableBuilder<int>(
                          valueListenable:
                              BasketRepository.basketItemCountNotifire,
                          builder: (context, value, child) {
                            return Badges(count: value);
                          },
                        ),
                      ),
                    ],
                  ),
                  label: 'سبد خرید'),
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
            ],
            currentIndex: selectedScreenIndex,
            onTap: (selectedIndex) {
              setState(() {
                _history.remove(selectedScreenIndex);
                _history.add(selectedScreenIndex);
                selectedScreenIndex = selectedIndex;
              });
            },
          ),
        ),
      ),
      onWillPop: () {
        return onWillPop();
      },
    );
  }

  Widget navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Offstage(
                  offstage: selectedScreenIndex != index, child: child),
            ),
          );
  }
}
