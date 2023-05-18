import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/cached_image.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/home_feature/data/datasource/favorite_datasource.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    super.key,
    required this.item,
  });

  final Product item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DeviseSize.getHeight(context) / 5.5,
      margin: const EdgeInsets.only(bottom: 15, left: 8, right: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CachedImage(
            imageUrl: item.image,
            radius: 6,
          ),
          SizedBox(width: DeviseSize.getWidth(context) / 85),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: DeviseSize.getHeight(context) / 100),
                Text(item.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 16)),
                SizedBox(height: DeviseSize.getHeight(context) / 50),
                Text(
                  item.previousPrice.priceFormatter(),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
                SizedBox(height: DeviseSize.getHeight(context) / 200),
                Text(
                  item.price.priceFormatter(),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          InkWell(
            onTap: () {
              favoriteManager.deleteFavorite(item);
            },
            child: Image.asset(
              'assets/images/delete.png',
              color: LightThemeColors.primaryColor,
              height: 30,
            ),
          )
        ],
      ),
    );
  }
}
