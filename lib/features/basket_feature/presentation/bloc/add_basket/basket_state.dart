part of 'basket_bloc.dart';

abstract class AddBasketState extends Equatable {
  const AddBasketState();

  @override
  List<Object> get props => [];
}

class AddBasketInitState extends AddBasketState {}

class AddBasketLoadingState extends AddBasketState {}

class AddBasketSuccessState extends AddBasketState {}

class AddBasketErrorState extends AddBasketState {
  final AppExeption exeption;

  const AddBasketErrorState(this.exeption);

  @override
  List<Object> get props => [exeption];
}
