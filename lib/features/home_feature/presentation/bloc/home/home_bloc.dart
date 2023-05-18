import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/home_feature/data/model/banner.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/home_feature/data/repository/banner.repository.dart';
import 'package:nike/features/home_feature/data/repository/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;
  HomeBloc(this.bannerRepository, this.productRepository)
      : super(HomeLoadingState()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeRequest || event is HomeRefresh) {
        emit(HomeLoadingState());
        try {
          final banners = await bannerRepository.getBanners();
          final latestProducts =
              await productRepository.getAllProducts(ProductSort.lastest);

          final popularProducts =
              await productRepository.getAllProducts(ProductSort.popular);

          emit(
            HomeSuccessState(
              banners: banners,
              latestProducts: latestProducts,
              popularProducts: popularProducts,
            ),
          );
        } catch (ex) {
          emit(
            HomeErrorState(
              exeption: ex is AppExeption ? ex : AppExeption(),
            ),
          );
        }
      }
    });
  }
}
