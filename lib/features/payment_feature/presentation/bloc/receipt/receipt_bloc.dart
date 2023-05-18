import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/payment_feature/data/model/receipt_model.dart';
import 'package:nike/features/payment_feature/data/repository/order_repository.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IOrderRepository orderRepository;
  ReceiptBloc(this.orderRepository) : super(ReceiptLoadingState()) {
    on<ReceiptEvent>((event, emit) async {
      if (event is ReceiptRequset) {
        try {
          emit(ReceiptLoadingState());

          final result = await orderRepository.getReceipt(event.orderId);

          emit(ReceiptSuccessState(result));
        } catch (ex) {
          emit(
            ReceiptErrorState(AppExeption()),
          );
        }
      }
    });
  }
}
