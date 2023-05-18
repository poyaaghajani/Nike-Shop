part of 'all_basket_bloc.dart';

abstract class AllBasketState {
  const AllBasketState();
}

// loading
class AllBasketLoadingState extends AllBasketState {}

// success
class AllBasketSuccessState extends AllBasketState {
  final AllBasketModel basketModel;

  const AllBasketSuccessState(this.basketModel);
}

// error
class AllBasketErrorState extends AllBasketState {
  final AppExeption exeption;

  const AllBasketErrorState(this.exeption);
}

// user must login/singup to access add product to basket or pay for products
class AllBasketAuthRequiredState extends AllBasketState {}

// if user logedIn but there is no any product in basket
class AllBasketEmptyState extends AllBasketState {}
