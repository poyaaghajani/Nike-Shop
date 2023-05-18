part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class ReceiptRequset extends ReceiptEvent {
  final int orderId;

  const ReceiptRequset(this.orderId);

  @override
  List<Object> get props => [orderId];
}
