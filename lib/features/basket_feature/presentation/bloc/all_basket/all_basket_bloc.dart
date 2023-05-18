import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/auth_feature/data/model/auth.dart';
import 'package:nike/features/basket_feature/data/model/all_basket_model.dart';
import 'package:nike/features/basket_feature/data/repository/basket_repository.dart';

part 'all_basket_event.dart';
part 'all_basket_state.dart';

class AllBasketBloc extends Bloc<AllBasketEvent, AllBasketState> {
  final IBasketRepository basketRepository;
  AllBasketBloc(this.basketRepository) : super(AllBasketLoadingState()) {
    on<AllBasketEvent>((event, emit) async {
      if (event is AllBasketRequest) {
        final auth = event.authModel;

        if (auth == null || auth.accessToken.isEmpty) {
          emit(AllBasketAuthRequiredState());
        } else {
          await loadBasketItems(emit, event.isRefrwshing);
        }
      } else if (event is BasketDeleteButtonPressed) {
        try {
          if (state is AllBasketSuccessState) {
            final successState = (state as AllBasketSuccessState);
            final basketItem = successState.basketModel.basketItems
                .firstWhere((element) => element.id == event.basketItemId);

            basketItem.deleteButtonLoading = true;

            emit(AllBasketSuccessState(successState.basketModel));
          }

          await basketRepository.deleteFromBasket(event.basketItemId);

          final successState = (state as AllBasketSuccessState);
          successState.basketModel.basketItems
              .removeWhere((element) => element.id == event.basketItemId);

          await basketRepository.getCount();

          if (successState.basketModel.basketItems.isEmpty) {
            emit(AllBasketEmptyState());
          } else {
            emit(calculatePriceInfo(successState.basketModel));
          }
        } catch (ex) {
          debugPrint(ex.toString());
        }
      } else if (event is BasketAuthModelChanged) {
        if (event.authModel == null || event.authModel!.accessToken.isEmpty) {
          emit(AllBasketAuthRequiredState());
        } else {
          if (state is AllBasketAuthRequiredState) {
            await loadBasketItems(emit, false);
          }
        }
      } else if (event is BasketPlusButtonPressed) {
        try {
          if (state is AllBasketSuccessState) {
            final successState = (state as AllBasketSuccessState);
            final index = successState.basketModel.basketItems
                .indexWhere((element) => element.id == event.basketItemId);

            successState.basketModel.basketItems[index].changeCountLoading =
                true;

            emit(AllBasketSuccessState(successState.basketModel));

            final newCount =
                successState.basketModel.basketItems[index].count + 1;

            await basketRepository.changeCount(event.basketItemId, newCount);

            successState.basketModel.basketItems
                .firstWhere((element) => element.id == event.basketItemId)
              ..count = newCount
              ..changeCountLoading = false;

            emit(calculatePriceInfo(successState.basketModel));

            await basketRepository.getCount();
          }
        } catch (ex) {
          debugPrint(ex.toString());
        }
      } else if (event is BasketMinusButtonPressed) {
        try {
          if (state is AllBasketSuccessState) {
            final successState = (state as AllBasketSuccessState);
            final index = successState.basketModel.basketItems
                .indexWhere((element) => element.id == event.basketItemId);

            successState.basketModel.basketItems[index].changeCountLoading =
                true;

            emit(AllBasketSuccessState(successState.basketModel));

            final newCount =
                successState.basketModel.basketItems[index].count - 1;

            await basketRepository.changeCount(event.basketItemId, newCount);

            successState.basketModel.basketItems
                .firstWhere((element) => element.id == event.basketItemId)
              ..count = newCount
              ..changeCountLoading = false;

            emit(calculatePriceInfo(successState.basketModel));

            await basketRepository.getCount();
          }
        } catch (ex) {
          debugPrint(ex.toString());
        }
      }
    });
  }

  Future<void> loadBasketItems(
      Emitter<AllBasketState> emit, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emit(AllBasketLoadingState());
      }

      final response = await basketRepository.getAllBasketProducts();

      if (response.basketItems.isEmpty) {
        emit(AllBasketEmptyState());
      } else {
        emit(AllBasketSuccessState(response));
      }
    } catch (ex) {
      emit(
        AllBasketErrorState(
          ex is AppExeption ? ex : AppExeption(),
        ),
      );
    }
  }

  // create a method to calculate price info in basket screen
  AllBasketSuccessState calculatePriceInfo(AllBasketModel basketModel) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shipingCost = 0;

    for (var basketItem in basketModel.basketItems) {
      totalPrice += basketItem.product.previousPrice * basketItem.count;
      payablePrice += basketItem.product.price * basketItem.count;
      shipingCost = payablePrice >= 250000 ? 0 : 30000;
    }

    basketModel.totalPrice = totalPrice;
    basketModel.payablePrice = payablePrice;
    basketModel.shipingCost = shipingCost;

    return AllBasketSuccessState(basketModel);
  }
}
