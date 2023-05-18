part of 'all_basket_bloc.dart';

abstract class AllBasketEvent extends Equatable {
  const AllBasketEvent();

  @override
  List<Object> get props => [];
}

// get all products in basket
class AllBasketRequest extends AllBasketEvent {
  final AuthModel? authModel;
  final bool isRefrwshing;

  const AllBasketRequest(this.authModel, {this.isRefrwshing = false});

  @override
  List<Object> get props => [authModel!];
}

// delete a product from basket
class BasketDeleteButtonPressed extends AllBasketEvent {
  final int basketItemId;

  const BasketDeleteButtonPressed(this.basketItemId);

  @override
  List<Object> get props => [basketItemId];
}

// increase the number of products in basket
class BasketPlusButtonPressed extends AllBasketEvent {
  final int basketItemId;

  const BasketPlusButtonPressed(this.basketItemId);

  @override
  List<Object> get props => [basketItemId];
}

// decrease the number of products in basket
class BasketMinusButtonPressed extends AllBasketEvent {
  final int basketItemId;

  const BasketMinusButtonPressed(this.basketItemId);

  @override
  List<Object> get props => [basketItemId];
}

// notify user is logedIn or not
class BasketAuthModelChanged extends AllBasketEvent {
  final AuthModel? authModel;

  const BasketAuthModelChanged(this.authModel);

  @override
  List<Object> get props => [authModel!];
}
