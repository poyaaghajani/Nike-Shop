part of 'all_products_bloc.dart';

abstract class AllProductsEvent extends Equatable {
  const AllProductsEvent();

  @override
  List<Object> get props => [];
}

class AllProductsRequest extends AllProductsEvent {
  final int sort;
  const AllProductsRequest(this.sort);

  @override
  List<Object> get props => [sort];
}
