import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/app_bar_icon.dart';
import 'package:nike/core/widgets/custom_state.dart';
import 'package:nike/core/widgets/loading_widget.dart';
import 'package:nike/features/payment_feature/data/repository/order_repository.dart';
import 'package:nike/features/payment_feature/presentation/bloc/order/order_record_bloc.dart';
import 'package:nike/features/profile_feature/presentation/widgets/record_item.dart';

class OrderRecordScreen extends StatelessWidget {
  const OrderRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          leading: const AppBarIcon(),
          title: Text(
            'سوابق سفارش',
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
          ),
        ),
        body: BlocProvider(
          create: (context) {
            final recodBloc = OrderRecordBloc(orderRepository);
            recodBloc.add(OrderRecordsRequest());
            return recodBloc;
          },
          child: BlocBuilder<OrderRecordBloc, OrderRecordState>(
            builder: (context, state) {
              if (state is OrderRecordLoadingState) {
                return const LoadingWidget();
              }
              if (state is OrderRecordSuccessState) {
                return state.orderModels.isEmpty
                    ? CustomState(
                        text: 'تا کنون خریدی انجام نداده اید',
                        image: 'assets/images/empty_cart.svg',
                        onTap: () {},
                        bgColor: Colors.grey.shade50,
                        buttonText: '',
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          top: DeviseSize.getHeight(context) / 60,
                          bottom: DeviseSize.getHeight(context) / 11,
                        ),
                        physics: defaultPhysics,
                        itemCount: state.orderModels.length,
                        itemBuilder: (context, index) {
                          final item = state.orderModels[index];

                          return RecordItem(item: item);
                        },
                      );
              }
              if (state is OrderRecordErrorState) {
                return CustomState(
                  text: state.exeption.message,
                  image: 'assets/images/no_data.svg',
                  onTap: () {
                    BlocProvider.of<OrderRecordBloc>(context)
                        .add(OrderRecordsRequest());
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
