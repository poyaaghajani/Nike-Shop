import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/app_bar_icon.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/profile_feature/presentation/widgets/favorite_item.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  final box = Hive.box<Product>('favoriteBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        leading: const AppBarIcon(),
        title: Text(
          'کفش های مورد علاقه',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, value, child) {
          return ListView.builder(
            physics: defaultPhysics,
            padding: EdgeInsets.only(
              bottom: DeviseSize.getHeight(context) / 10,
              top: DeviseSize.getHeight(context) / 50,
            ),
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final item = box.values.toList()[index];

              return FavoriteItem(item: item);
            },
          );
        },
      ),
    );
  }
}
