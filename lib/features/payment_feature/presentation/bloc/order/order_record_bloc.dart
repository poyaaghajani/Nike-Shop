import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/payment_feature/data/model/order_record_model.dart';
import 'package:nike/features/payment_feature/data/repository/order_repository.dart';

part 'order_record_event.dart';
part 'order_record_state.dart';

class OrderRecordBloc extends Bloc<OrderRecordEvent, OrderRecordState> {
  final IOrderRepository orderRepository;

  OrderRecordBloc(this.orderRepository) : super(OrderRecordLoadingState()) {
    on<OrderRecordEvent>((event, emit) async {
      if (event is OrderRecordsRequest) {
        try {
          emit(OrderRecordLoadingState());

          final result = await orderRepository.getOrderRecords();

          emit(OrderRecordSuccessState(result));
        } catch (ex) {
          emit(
            OrderRecordErrorState(AppExeption()),
          );
        }
      }
    });
  }
}
