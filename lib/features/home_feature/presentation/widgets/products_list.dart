import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/cached_image.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/home_feature/presentation/screens/product_detail_screen.dart';
import 'package:nike/features/home_feature/data/datasource/favorite_datasource.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({
    super.key,
    required this.products,
    required this.title,
    required this.ontap,
  });

  final List<Product> products;
  final String title;

  final void Function()? ontap;

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: DeviseSize.getHeight(context) / 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: widget.ontap,
                child: const Text(
                  'مشاهده همه',
                ),
              ),
            ],
          ),
          SizedBox(
            height: DeviseSize.getHeight(context) / 3,
            child: ListView.builder(
              physics: defaultPhysics,
              scrollDirection: Axis.horizontal,
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final item = widget.products[index];
                return Container(
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductDetailScreen(
                              product: widget.products[index],
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: DeviseSize.getWidth(context) / 2,
                              height: DeviseSize.getHeight(context) / 4.5,
                              child: CachedImage(
                                imageUrl: item.image,
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
                                      if (favoriteManager
                                          .isFavorite(widget.products[index])) {
                                        favoriteManager.deleteFavorite(
                                            widget.products[index]);
                                      } else {
                                        favoriteManager.addFavorite(
                                            widget.products[index]);
                                      }
                                    });
                                  },
                                  child: Icon(
                                    favoriteManager
                                            .isFavorite(widget.products[index])
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
                        SizedBox(
                          width: DeviseSize.getWidth(context) / 2,
                          child: Text(
                            widget.products[index].title,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.previousPrice.priceFormatter(),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(item.price.priceFormatter())
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
