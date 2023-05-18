import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/custom_buton.dart';
import 'package:nike/core/widgets/custom_state.dart';
import 'package:nike/core/widgets/loading_widget.dart';
import 'package:nike/core/widgets/price_info_line.dart';
import 'package:nike/features/payment_feature/data/repository/order_repository.dart';
import 'package:nike/features/payment_feature/presentation/bloc/receipt/receipt_bloc.dart';
import 'package:nike/features/profile_feature/presentation/screen/order_record_screen.dart';

class RecepitScreen extends StatelessWidget {
  const RecepitScreen({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.abc,
            size: 0,
          ),
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 2,
          title: Text(
            'رسید پرداخت',
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey.shade100,
        ),
        body: BlocProvider(
          create: (context) {
            final receiptBloc = ReceiptBloc(orderRepository);
            receiptBloc.add(ReceiptRequset(orderId));
            return receiptBloc;
          },
          child: BlocBuilder<ReceiptBloc, ReceiptState>(
            builder: (context, state) {
              if (state is ReceiptLoadingState) {
                return const LoadingWidget();
              }
              if (state is ReceiptSuccessState) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20, left: 8, right: 8, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 5),
                              child: Text(
                                state.receiptModel.purchaseSuccess
                                    ? 'پرداخت یا موفقیت انجام شد'
                                    : 'پرداخت نا موفق',
                                style: const TextStyle(
                                    color: LightThemeColors.primaryColor,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'وضعیت سفارش',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(state.receiptModel.paymentStatus),
                                ],
                              ),
                            ),
                            const PriceInfoLine(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'مبلغ',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    state.receiptModel.payablePrice
                                        .priceFormatter(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const OrderRecordScreen();
                                },
                              ),
                            );
                          },
                          child: const Text('سوابق سفارش'),
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                          width: DeviseSize.getWidth(context) / 2.3,
                          height: DeviseSize.getHeight(context) / 17,
                          onPressed: () {
                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            );
                          },
                          text: 'بازگشت به صفحه اصلی',
                          color: LightThemeColors.primaryColor,
                        ),
                      ],
                    ),
                  ],
                );
              }
              if (state is ReceiptErrorState) {
                return CustomState(
                  text: state.exeption.message,
                  image: 'assets/images/no_data.svg',
                  onTap: () {
                    BlocProvider.of<ReceiptBloc>(context)
                        .add(ReceiptRequset(orderId));
                  },
                  buttonText: 'تلاش دوباره',
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
