import 'package:flutter/material.dart';
import 'package:nike/core/utils/api_service.dart';
import 'package:nike/features/basket_feature/data/datasource/basket_datasource.dart';
import 'package:nike/features/basket_feature/data/model/all_basket_model.dart';
import 'package:nike/features/basket_feature/data/model/add_basket_model.dart';

final basketRepository = BasketRepository(BasketRemoteDatasource(dio));

abstract class IBasketRepository {
  Future<AddBasketModel> addToBasket(int productId);

  Future<AddBasketModel> changeCount(int basketItemId, int count);

  Future<void> deleteFromBasket(int basketItemId);

  Future<int> getCount();

  Future<AllBasketModel> getAllBasketProducts();
}

class BasketRepository implements IBasketRepository {
  final IBasketDatasource basketDatasource;

  static ValueNotifier<int> basketItemCountNotifire = ValueNotifier(0);

  BasketRepository(this.basketDatasource);

  // add a product to basket
  @override
  Future<AddBasketModel> addToBasket(int productId) {
    return basketDatasource.addToBasket(productId);
  }

  // change count of a product in basket
  @override
  Future<AddBasketModel> changeCount(int basketItemId, int count) {
    return basketDatasource.changeCount(basketItemId, count);
  }

  // delete product from basket
  @override
  Future<void> deleteFromBasket(int basketItemId) {
    return basketDatasource.deleteFromBasket(basketItemId);
  }

  // get all products in basket
  @override
  Future<AllBasketModel> getAllBasketProducts() {
    return basketDatasource.getAllBasketProducts();
  }

  // number of basket items
  @override
  Future<int> getCount() async {
    final count = await basketDatasource.getCount();
    basketItemCountNotifire.value = count;

    return count;
  }
}
