import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/custom_state.dart';
import 'package:nike/core/widgets/loading_widget.dart';
import 'package:nike/features/auth_feature/data/repository/auth_repository.dart';
import 'package:nike/features/auth_feature/presentation/screen/auth_screen.dart';
import 'package:nike/features/basket_feature/data/repository/basket_repository.dart';
import 'package:nike/features/basket_feature/presentation/bloc/all_basket/all_basket_bloc.dart';
import 'package:nike/features/basket_feature/presentation/widgets/basket_item.dart';
import 'package:nike/core/widgets/price_info.dart';
import 'package:nike/features/payment_feature/presentation/screen/payment_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  late AllBasketBloc? basketBloc;
  late StreamSubscription? subscription;
  bool isVisable = false;

  // controller foe refresh list
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifire.addListener(changeNotifireListener);
  }

  // crate a method to listen user authorization state
  void changeNotifireListener() {
    basketBloc?.add(
      BasketAuthModelChanged(
        AuthRepository.authChangeNotifire.value,
      ),
    );
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifire.removeListener(changeNotifireListener);
    basketBloc?.close();
    subscription?.cancel();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocProvider<AllBasketBloc>(
          create: (context) {
            final bloc = AllBasketBloc(basketRepository);
            subscription = bloc.stream.listen((state) {
              setState(() {
                isVisable = state is AllBasketSuccessState;
              });
              if (refreshController.isRefresh) {
                if (state is AllBasketSuccessState) {
                  refreshController.refreshCompleted();
                } else if (state is AllBasketErrorState) {
                  refreshController.refreshFailed();
                }
              }
            });
            basketBloc = bloc;
            bloc.add(AllBasketRequest(AuthRepository.authChangeNotifire.value));

            return bloc;
          },
          child: BlocBuilder<AllBasketBloc, AllBasketState>(
            builder: (context, state) {
              if (state is AllBasketLoadingState) {
                return const LoadingWidget();
              }
              if (state is AllBasketSuccessState) {
                return SmartRefresher(
                  controller: refreshController,
                  header: const ClassicHeader(
                    completeText: 'لیست شما به روز شد',
                    refreshingText: 'در حال به روز رسانی',
                    idleText: 'به سمت پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطایی وجود دارد',
                    spacing: 4,
                    refreshingIcon: CupertinoActivityIndicator(),
                    completeIcon: Icon(
                      CupertinoIcons.check_mark_circled,
                      color: Colors.teal,
                      size: 20,
                    ),
                  ),
                  onRefresh: () {
                    basketBloc?.add(
                      AllBasketRequest(
                        AuthRepository.authChangeNotifire.value,
                        isRefrwshing: true,
                      ),
                    );
                  },
                  child: ListView.builder(
                    physics: defaultPhysics,
                    itemCount: state.basketModel.basketItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.basketModel.basketItems.length) {
                        final item = state.basketModel.basketItems[index];

                        return BasketItem(
                          item: item,
                          onTap: () {
                            basketBloc?.add(BasketDeleteButtonPressed(item.id));
                          },
                          increment: () {
                            if (item.count < 5) {
                              basketBloc?.add(BasketPlusButtonPressed(item.id));
                            }
                          },
                          decrement: () {
                            if (item.count > 1) {
                              basketBloc
                                  ?.add(BasketMinusButtonPressed(item.id));
                            }
                          },
                        );
                      } else {
                        return PriceInfo(
                          payablePrice: state.basketModel.payablePrice,
                          totalPrice: state.basketModel.totalPrice,
                          shipingCost: state.basketModel.shipingCost,
                          buttom: DeviseSize.getHeight(context) / 5.5,
                        );
                      }
                    },
                  ),
                );
              }
              if (state is AllBasketErrorState) {
                return CustomState(
                  text: state.exeption.message,
                  image: 'assets/images/no_data.svg',
                  onTap: () {
                    BlocProvider.of<AllBasketBloc>(context).add(
                      AllBasketRequest(
                        AuthRepository.authChangeNotifire.value,
                      ),
                    );
                  },
                  buttonText: 'تلاش دوباره',
                );
              }
              if (state is AllBasketAuthRequiredState) {
                return CustomState(
                  text: 'برای مشاهده سبد خرید, ابتدا وارد حساب کاربری خود شوید',
                  image: 'assets/images/auth_required.svg',
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const AuthScreen();
                        },
                      ),
                    );
                  },
                  buttonText: 'ورود به حساب کاربری',
                );
              }
              if (state is AllBasketEmptyState) {
                return CustomState(
                  text: 'سبد خرید شما در حال حاضر خالی است',
                  image: 'assets/images/empty_cart.svg',
                  onTap: () {},
                  bgColor: Colors.grey.shade50,
                  buttonText: '',
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Visibility(
        visible: isVisable,
        child: Padding(
          padding: EdgeInsets.only(bottom: DeviseSize.getHeight(context) / 12),
          child: FloatingActionButton.extended(
            backgroundColor: LightThemeColors.deepNavy,
            onPressed: () {
              final state = basketBloc?.state;

              final newState = (state as AllBasketSuccessState);

              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) {
                    return PaymentScreen(
                      payablePrice: newState.basketModel.payablePrice,
                      totalPrice: newState.basketModel.totalPrice,
                      shipingCost: newState.basketModel.shipingCost,
                    );
                  },
                ),
              );
            },
            label: const Text('پرداخت'),
          ),
        ),
      ),
    );
  }
}
