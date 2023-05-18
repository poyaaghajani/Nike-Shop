import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String image;
  @HiveField(3)
  int price;
  @HiveField(4)
  int discount;
  @HiveField(5)
  int previousPrice;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
    required this.previousPrice,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        price = json['previous_price'] == null
            ? json['price'] - json['discount']
            : json['price'],
        discount = json['discount'],
        previousPrice = json['previous_price'] ?? json['price'];
}

class ProductSort {
  static const int lastest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;

  static const List<String> names = [
    'جدیدترین ها',
    'پربازدیدترین ها',
    'گران ترین ها',
    'ارزان ترین ها',
  ];
}
