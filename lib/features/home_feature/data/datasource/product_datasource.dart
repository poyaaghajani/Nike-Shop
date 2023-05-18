import 'package:dio/dio.dart';
import 'package:nike/core/utils/validator.dart';
import 'package:nike/features/home_feature/data/model/product.dart';

abstract class IProductDatasource {
  Future<List<Product>> getAllProducts(int sort);

  Future<List<Product>> searchProducts(String search);
}

class ProductRemoteDatasource implements IProductDatasource {
  final Dio dio;
  ProductRemoteDatasource(this.dio);

  @override
  Future<List<Product>> getAllProducts(int sort) async {
    final response = await dio.get('product/list?sort=$sort');
    validateResponse(response);

    final List<Product> products = [];

    for (var element in (response.data as List)) {
      products.add(Product.fromJson(element));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProducts(String search) async {
    final response = await dio.get('product/search?q=$search');
    validateResponse(response);

    final List<Product> products = [];

    for (var element in (response.data as List)) {
      products.add(Product.fromJson(element));
    }

    return products;
  }
}
