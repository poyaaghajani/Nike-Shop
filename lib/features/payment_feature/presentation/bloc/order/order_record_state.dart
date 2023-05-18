part of 'order_record_bloc.dart';

abstract class OrderRecordState extends Equatable {
  const OrderRecordState();

  @override
  List<Object> get props => [];
}

class OrderRecordLoadingState extends OrderRecordState {}

class OrderRecordSuccessState extends OrderRecordState {
  final List<OrderRecordModel> orderModels;

  const OrderRecordSuccessState(this.orderModels);

  @override
  List<Object> get props => [orderModels];
}

class OrderRecordErrorState extends OrderRecordState {
  final AppExeption exeption;

  const OrderRecordErrorState(this.exeption);

  @override
  List<Object> get props => [exeption];
}
