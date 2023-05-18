import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/basket_feature/data/repository/basket_repository.dart';

part 'basket_event.dart';
part 'basket_state.dart';

class AddBasketBloc extends Bloc<AddBasketEvent, AddBasketState> {
  final IBasketRepository basketRepository;

  AddBasketBloc(this.basketRepository) : super(AddBasketInitState()) {
    on<AddBasketEvent>(
      (event, emit) async {
        if (event is AddBasketButtonPressed) {
          try {
            emit(AddBasketLoadingState());

            await basketRepository.addToBasket(event.productId);

            await basketRepository.getCount();

            emit(AddBasketSuccessState());
          } catch (ex) {
            emit(AddBasketErrorState(AppExeption()));
          }
        }
      },
    );
  }
}
