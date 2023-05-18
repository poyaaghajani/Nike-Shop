part of 'basket_bloc.dart';

abstract class AddBasketEvent extends Equatable {
  const AddBasketEvent();

  @override
  List<Object> get props => [];
}

class AddBasketButtonPressed extends AddBasketEvent {
  final int productId;

  const AddBasketButtonPressed(this.productId);
}
