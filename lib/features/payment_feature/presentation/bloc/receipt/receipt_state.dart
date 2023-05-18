part of 'receipt_bloc.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

class ReceiptLoadingState extends ReceiptState {}

class ReceiptSuccessState extends ReceiptState {
  final ReceiptModel receiptModel;

  const ReceiptSuccessState(this.receiptModel);

  @override
  List<Object> get props => [receiptModel];
}

class ReceiptErrorState extends ReceiptState {
  final AppExeption exeption;

  const ReceiptErrorState(this.exeption);

  @override
  List<Object> get props => [exeption];
}
