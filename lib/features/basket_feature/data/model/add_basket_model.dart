class AddBasketModel {
  final int productId;
  final int cartItemId;
  final int count;

  AddBasketModel.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartItemId = json['id'],
        count = json['count'];
}
