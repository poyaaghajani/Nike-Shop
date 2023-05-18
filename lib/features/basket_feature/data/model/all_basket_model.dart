import 'package:nike/features/basket_feature/data/model/basket_list_model.dart';

class AllBasketModel {
  final List<BasketListModel> basketItems;
  int payablePrice;
  int totalPrice;
  int shipingCost;

  AllBasketModel.fromJson(Map<String, dynamic> json)
      : basketItems = BasketListModel.parseJsonArray(
          json['cart_items'],
        ),
        payablePrice = json['payable_price'],
        totalPrice = json['total_price'],
        shipingCost = json['shipping_cost'];
}
