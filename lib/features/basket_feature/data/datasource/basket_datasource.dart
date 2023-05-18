import 'package:dio/dio.dart';
import 'package:nike/core/utils/validator.dart';
import 'package:nike/features/basket_feature/data/model/all_basket_model.dart';
import 'package:nike/features/basket_feature/data/model/add_basket_model.dart';

abstract class IBasketDatasource {
  Future<AddBasketModel> addToBasket(int productId);

  Future<AddBasketModel> changeCount(int basketItemId, int count);

  Future<void> deleteFromBasket(int basketItemId);

  Future<int> getCount();

  Future<AllBasketModel> getAllBasketProducts();
}

class BasketRemoteDatasource implements IBasketDatasource {
  final Dio dio;

  BasketRemoteDatasource(this.dio);

  // add a product to basket
  @override
  Future<AddBasketModel> addToBasket(int productId) async {
    final response = await dio.post('cart/add', data: {
      'product_id': productId,
    });
    validateResponse(response);

    return AddBasketModel.fromJson(response.data);
  }

  // change count of a product in basket
  @override
  Future<AddBasketModel> changeCount(int basketItemId, int count) async {
    final response = await dio.post('cart/changeCount', data: {
      'cart_item_id': basketItemId,
      'count': count,
    });

    validateResponse(response);

    return AddBasketModel.fromJson(response.data);
  }

  // delete product from basket
  @override
  Future<void> deleteFromBasket(int cartItemId) async {
    await dio.post('cart/remove', data: {
      'cart_item_id': cartItemId,
    });
  }

  // get all products in basket
  @override
  Future<AllBasketModel> getAllBasketProducts() async {
    final response = await dio.get('cart/list');
    validateResponse(response);

    return AllBasketModel.fromJson(response.data);
  }

  // number of basket items
  @override
  Future<int> getCount() async {
    final response = await dio.get('cart/count');
    validateResponse(response);

    return response.data['count'];
  }
}
