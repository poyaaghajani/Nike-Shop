import 'package:hive/hive.dart';
import 'package:nike/features/home_feature/data/model/product.dart';

final favoriteManager = FavoriteLocalDatasource();

class FavoriteLocalDatasource {
  final box = Hive.box<Product>('favoriteBox');

  // add to favorites
  void addFavorite(Product products) {
    box.put(products.id, products);
  }

  // delete from favorites
  void deleteFavorite(Product products) {
    box.delete(products.id);
  }

  // get all favorites products
  List<Product> get favorites => box.values.toList();

  // is favorite or not
  bool isFavorite(Product products) {
    return box.containsKey(products.id);
  }
}
