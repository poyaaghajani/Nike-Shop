part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final AppExeption exeption;

  const HomeErrorState({required this.exeption});

  @override
  List<Object> get props => [exeption];
}

class HomeSuccessState extends HomeState {
  final List<BannerModel> banners;
  final List<Product> latestProducts;
  final List<Product> popularProducts;

  const HomeSuccessState({
    required this.banners,
    required this.latestProducts,
    required this.popularProducts,
  });

  @override
  List<Object> get props => [banners, latestProducts, popularProducts];
}
