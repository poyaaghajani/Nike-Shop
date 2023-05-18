import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/params/submit_order_params.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/app_bar_icon.dart';
import 'package:nike/core/widgets/custom_buton.dart';
import 'package:nike/core/widgets/custom_snackbar.dart';
import 'package:nike/core/widgets/loading_widget.dart';
import 'package:nike/core/widgets/price_info.dart';
import 'package:nike/features/payment_feature/data/repository/order_repository.dart';
import 'package:nike/features/payment_feature/presentation/bloc/payment/payment_bloc.dart';
import 'package:nike/features/payment_feature/presentation/screen/payment_gateway_screen.dart';
import 'package:nike/features/payment_feature/presentation/screen/receipt_screen.dart';
import 'package:nike/features/payment_feature/presentation/widgets/payment_textfiled.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.payablePrice,
    required this.totalPrice,
    required this.shipingCost,
  });

  final int payablePrice;
  final int totalPrice;
  final int shipingCost;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final postalCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  late StreamSubscription? subscription;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    addressController.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const AppBarIcon(),
          centerTitle: true,
          elevation: 2,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'انتخاب شیوه پرداخت',
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
          ),
        ),
        body: BlocProvider<PaymentBloc>(
          create: (context) {
            final orderBloc = PaymentBloc(orderRepository);

            subscription = orderBloc.stream.listen((state) {
              if (state is PaymentErrorState) {
                CustomSnackbar.showSnack(
                  context,
                  state.exeption.message,
                  Colors.white,
                  LightThemeColors.deepNavy,
                );
              } else if (state is PaymentSuccessState) {
                if (state.orderModel.bankGatewayUrl.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PaymentGatewayScreen(
                          bankGateway: state.orderModel.bankGatewayUrl,
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RecepitScreen(
                          orderId: state.orderModel.orderId,
                        );
                      },
                    ),
                  );
                }
              }
            });
            return orderBloc;
          },
          child: SafeArea(
            child: CustomScrollView(
              physics: defaultPhysics,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          PaymentTextfiled(
                            text: 'نام',
                            keyType: TextInputType.text,
                            controller: firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'پر کردن فیلد الزامیست';
                              } else {
                                return null;
                              }
                            },
                          ),
                          PaymentTextfiled(
                            text: 'نام خانوادگی',
                            keyType: TextInputType.text,
                            controller: lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'پر کردن فیلد الزامیست';
                              } else {
                                return null;
                              }
                            },
                          ),
                          PaymentTextfiled(
                            text: 'کد پستی',
                            keyType: TextInputType.number,
                            controller: postalCodeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'پر کردن فیلد الزامیست';
                              } else if (value.characters.length < 10) {
                                return 'کد پستی باید 10 رقم باشد';
                              } else {
                                return null;
                              }
                            },
                          ),
                          PaymentTextfiled(
                            text: 'شماره تماس',
                            keyType: TextInputType.number,
                            controller: phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'پر کردن فیلد الزامیست';
                              } else if (value.characters.length < 11) {
                                return ' شماره تماس باید 11 رقم باشد';
                              } else {
                                return null;
                              }
                            },
                          ),
                          PaymentTextfiled(
                            text: 'آدرس تحویل گیرنده',
                            keyType: TextInputType.text,
                            controller: addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'پر کردن فیلد الزامیست';
                              } else if (value.characters.length <= 20) {
                                return 'آدرس حداقل باید 20 کلمه باشد';
                              } else {
                                return null;
                              }
                            },
                          ),
                          PriceInfo(
                            payablePrice: widget.payablePrice,
                            totalPrice: widget.totalPrice,
                            shipingCost: widget.shipingCost,
                            buttom: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: BlocBuilder<PaymentBloc, PaymentState>(
                              builder: (context, state) {
                                if (state is PaymentLoadingState) {
                                  return const LoadingWidget();
                                } else {
                                  return paymentButtons(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row paymentButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: Size(
              DeviseSize.getWidth(context) / 2.3,
              DeviseSize.getHeight(context) / 17,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: const BorderSide(
                width: 2, color: LightThemeColors.primaryColor),
          ),
          onPressed: () {
            BlocProvider.of<PaymentBloc>(context).add(
              PaymentSubmitOrder(
                SubmitOrderParams(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneController.text,
                  postalCode: postalCodeController.text,
                  address: addressController.text,
                  paymentMethod: PaymentMethod.cashOnDelivery,
                ),
              ),
            );
          },
          child: const Text('پرداخت در محل'),
        ),
        const SizedBox(width: 8),
        CustomButton(
          width: DeviseSize.getWidth(context) / 2.3,
          height: DeviseSize.getHeight(context) / 17,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              BlocProvider.of<PaymentBloc>(context).add(
                PaymentSubmitOrder(
                  SubmitOrderParams(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    phoneNumber: phoneController.text,
                    postalCode: postalCodeController.text,
                    address: addressController.text,
                    paymentMethod: PaymentMethod.online,
                  ),
                ),
              );
            }
          },
          text: 'پرداخت اینترنتی',
          color: LightThemeColors.primaryColor,
        ),
      ],
    );
  }
}
