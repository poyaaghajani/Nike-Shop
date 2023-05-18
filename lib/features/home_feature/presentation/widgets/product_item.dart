import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/cached_image.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/home_feature/data/datasource/favorite_datasource.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key, required this.products});

  final Product products;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: DeviseSize.getWidth(context),
                child: CachedImage(
                  imageUrl: widget.products.image,
                  fit: BoxFit.cover,
                  radius: 12,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (favoriteManager.isFavorite(widget.products)) {
                          favoriteManager.deleteFavorite(widget.products);
                        } else {
                          favoriteManager.addFavorite(widget.products);
                        }
                      });
                    },
                    child: Icon(
                      favoriteManager.isFavorite(widget.products)
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: LightThemeColors.purpule,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Text(
              widget.products.title,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.products.previousPrice.priceFormatter(),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  decoration: TextDecoration.lineThrough,
                ),
          ),
          const SizedBox(height: 2),
          Text(widget.products.price.priceFormatter())
        ],
      ),
    );
  }
}
