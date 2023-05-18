import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/cached_image.dart';
import 'package:nike/core/widgets/line.dart';
import 'package:nike/features/payment_feature/data/model/order_record_model.dart';

class RecordItem extends StatelessWidget {
  const RecordItem({
    super.key,
    required this.item,
  });

  final OrderRecordModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('شناسه سفارش'),
              Text(item.id.toString()),
            ],
          ),
          SizedBox(height: DeviseSize.getHeight(context) / 45),
          SizedBox(
            height: DeviseSize.getHeight(context) / 6,
            child: ListView.builder(
              physics: defaultPhysics,
              scrollDirection: Axis.horizontal,
              itemCount: item.items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: CachedImage(
                          imageUrl: item.items[index].image,
                          radius: 6,
                        ),
                      ),
                    ),
                    Text(
                      'x ${item.productCount[index].toString()}',
                      style: const TextStyle(
                        color: LightThemeColors.navy,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: DeviseSize.getHeight(context) / 85),
          const Line(),
          SizedBox(height: DeviseSize.getHeight(context) / 45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('مبلغ کل'),
              Text(
                item.total.priceFormatter(),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('مبلغ پرداخت شده'),
              Text(item.payable.priceFormatter()),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('سود شما از خرید'),
              Text(item.profit.priceFormatter()),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('وضعیت پرداخت'),
              Text(item.paymentStatus),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تاریخ سفارش'),
              Text(item.date),
            ],
          ),
        ],
      ),
    );
  }
}
