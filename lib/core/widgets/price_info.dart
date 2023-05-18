import 'package:flutter/material.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/widgets/price_info_line.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo({
    super.key,
    required this.payablePrice,
    required this.totalPrice,
    required this.shipingCost,
    required this.buttom,
  });

  final int payablePrice;
  final int totalPrice;
  final int shipingCost;
  final double buttom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 5, top: 20),
          child: Text(
            'جزییات خرید',
            style:
                Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: buttom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    Text(
                      totalPrice.priceFormatter(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const PriceInfoLine(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    Text(
                      shipingCost.priceFormatter(),
                    ),
                  ],
                ),
              ),
              const PriceInfoLine(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ قابل پرداخت'),
                    Text(
                      payablePrice.priceFormatter(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
