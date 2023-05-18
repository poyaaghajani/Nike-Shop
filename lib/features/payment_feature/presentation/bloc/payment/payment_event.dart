part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

// pay for order
class PaymentSubmitOrder extends PaymentEvent {
  final SubmitOrderParams params;

  const PaymentSubmitOrder(this.params);
}
