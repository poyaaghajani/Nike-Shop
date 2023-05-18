import 'package:nike/core/utils/api_service.dart';
import 'package:nike/features/home_feature/data/datasource/product_datasource.dart';
import 'package:nike/features/home_feature/data/model/product.dart';

final productRepository = ProductRepository(ProductRemoteDatasource(dio));

abstract class IProductRepository {
  Future<List<Product>> getAllProducts(int sort);

  Future<List<Product>> searchProducts(String search);
}

class ProductRepository implements IProductRepository {
  final IProductDatasource productDatasource;
  ProductRepository(this.productDatasource);

  @override
  Future<List<Product>> getAllProducts(int sort) {
    return productDatasource.getAllProducts(sort);
  }

  @override
  Future<List<Product>> searchProducts(String search) {
    return productDatasource.searchProducts(search);
  }
}
