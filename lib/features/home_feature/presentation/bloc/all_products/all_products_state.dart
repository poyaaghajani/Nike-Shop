part of 'all_products_bloc.dart';

abstract class AllProductsState extends Equatable {
  const AllProductsState();

  @override
  List<Object> get props => [];
}

class AllProductsLoadingState extends AllProductsState {}

// get all products by sort
class AllProductsSuccessState extends AllProductsState {
  final List<Product> products;
  final int sort;
  final List<String> sortNames;
  const AllProductsSuccessState(this.products, this.sort, this.sortNames);

  @override
  List<Object> get props => [products, sort, sortNames];
}

class AllProductsErrorState extends AllProductsState {
  final AppExeption exeption;
  const AllProductsErrorState(this.exeption);

  @override
  List<Object> get props => [exeption];
}
