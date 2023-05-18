import 'package:nike/features/home_feature/data/model/product.dart';

class BasketListModel {
  Product product;
  int id;
  int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  BasketListModel.fromJsom(Map<String, dynamic> json)
      : product = Product.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<BasketListModel> parseJsonArray(List<dynamic> json) {
    final List<BasketListModel> basketItems = [];

    for (var element in json) {
      basketItems.add(BasketListModel.fromJsom(element));
    }

    return basketItems;
  }
}
