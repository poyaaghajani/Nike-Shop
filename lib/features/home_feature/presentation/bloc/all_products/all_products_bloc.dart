import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/home_feature/data/repository/product_repository.dart';

part 'all_products_event.dart';
part 'all_products_state.dart';

class AllProductsBloc extends Bloc<AllProductsEvent, AllProductsState> {
  final IProductRepository productRepository;

  AllProductsBloc(this.productRepository) : super(AllProductsLoadingState()) {
    on<AllProductsEvent>((event, emit) async {
      if (event is AllProductsRequest) {
        try {
          emit(AllProductsLoadingState());

          final result = await productRepository.getAllProducts(event.sort);

          emit(AllProductsSuccessState(result, event.sort, ProductSort.names));
        } catch (ex) {
          emit(
            AllProductsErrorState(AppExeption()),
          );
        }
      }
    });
  }
}
