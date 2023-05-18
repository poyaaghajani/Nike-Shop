part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitState extends PaymentState {}

class PaymentLoadingState extends PaymentState {}

class PaymentSuccessState extends PaymentState {
  final OrderModel orderModel;

  const PaymentSuccessState(this.orderModel);

  @override
  List<Object> get props => [orderModel];
}

class PaymentErrorState extends PaymentState {
  final AppExeption exeption;

  const PaymentErrorState(this.exeption);

  @override
  List<Object> get props => [exeption];
}
