import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/params/submit_order_params.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/payment_feature/data/model/order_model.dart';
import 'package:nike/features/payment_feature/data/repository/order_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final IOrderRepository orderRepository;
  PaymentBloc(this.orderRepository) : super(PaymentInitState()) {
    on<PaymentEvent>(
      (event, emit) async {
        if (event is PaymentSubmitOrder) {
          try {
            emit(PaymentLoadingState());

            final result = await orderRepository.submitOrder(event.params);

            emit(PaymentSuccessState(result));
          } catch (ex) {
            emit(
              PaymentErrorState(AppExeption()),
            );
          }
        }
      },
    );
  }
}
