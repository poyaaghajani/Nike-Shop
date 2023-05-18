class OrderModel {
  int orderId;
  String bankGatewayUrl;

  OrderModel.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}
