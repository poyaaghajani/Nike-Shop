import 'package:nike/features/home_feature/data/model/product.dart';

class OrderRecordModel {
  int id;
  int payable;
  int total;
  int profit;
  String paymentStatus;
  String paymentMethod;
  String date;
  List<Product> items;
  List<int> productCount;

  OrderRecordModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payable = json['payable'],
        total = json['total'],
        profit = json['total'] - json['payable'],
        paymentStatus = (json['payment_status'] == 'waiting')
            ? 'در انتظار پرداخت'
            : 'پرداخت شده',
        paymentMethod = json['payment_method'],
        date = json['date'],
        items = (json['order_items'] as List)
            .map((item) => Product.fromJson(item['product']))
            .toList(),
        productCount = (json['order_items'] as List)
            .map((e) => e['count'])
            .toList()
            .cast<int>();
}
