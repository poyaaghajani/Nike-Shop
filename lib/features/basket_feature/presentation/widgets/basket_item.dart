import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/cached_image.dart';
import 'package:nike/core/widgets/line.dart';
import 'package:nike/features/basket_feature/data/model/basket_list_model.dart';
import 'package:nike/features/basket_feature/presentation/widgets/basket_count.dart';

class BasketItem extends StatelessWidget {
  const BasketItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.increment,
    required this.decrement,
  });

  final BasketListModel item;
  final void Function()? onTap;
  final void Function()? increment;
  final void Function()? decrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      height: DeviseSize.getHeight(context) / 3.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: DeviseSize.getWidth(context) / 3,
                height: DeviseSize.getHeight(context) / 7,
                child: CachedImage(
                  imageUrl: item.product.image,
                  radius: 8,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  item.product.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  right: DeviseSize.getWidth(context) / 19, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('تعداد',
                          style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: increment,
                            child: const BasketCount(
                              icon: CupertinoIcons.add,
                            ),
                          ),
                          const SizedBox(width: 15),
                          item.changeCountLoading
                              ? const CupertinoActivityIndicator()
                              : Text(item.count.toString()),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: decrement,
                            child: const BasketCount(
                              icon: CupertinoIcons.minus,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        item.product.previousPrice.priceFormatter(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                      Text(
                        item.product.price.priceFormatter(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Line(),
          SizedBox(height: DeviseSize.getHeight(context) / 60),
          item.deleteButtonLoading
              ? const CupertinoActivityIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/delete.png',
                      height: 17,
                      color: LightThemeColors.primaryColor,
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text('حذف از سبد خرید'),
                    ),
                  ],
                ),
          SizedBox(height: DeviseSize.getHeight(context) / 60),
        ],
      ),
    );
  }
}
