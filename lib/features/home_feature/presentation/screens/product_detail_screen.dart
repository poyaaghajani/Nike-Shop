import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/extensions/price_formatter.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/app_bar_icon.dart';
import 'package:nike/core/widgets/cached_image.dart';
import 'package:nike/core/widgets/custom_snackbar.dart';
import 'package:nike/features/basket_feature/data/repository/basket_repository.dart';
import 'package:nike/features/basket_feature/presentation/bloc/add_basket/basket_bloc.dart';
import 'package:nike/features/comment_feature/presentation/widgets/comment_list.dart';
import 'package:nike/features/home_feature/data/datasource/favorite_datasource.dart';
import 'package:nike/features/home_feature/data/model/product.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFabVisable = true;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // create a valiable to listen subscription
  late StreamSubscription<AddBasketState>? stateSubscription;

  // if user hasn't any subscription, dipose that
  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<AddBasketBloc>(
        create: (context) {
          final basketBloc = AddBasketBloc(basketRepository);

          stateSubscription = basketBloc.stream.listen((state) {
            if (state is AddBasketSuccessState) {
              CustomSnackbar.showSnack(
                context,
                'محصول به سبد خرید شما اضافه شد',
                Colors.white,
                LightThemeColors.deepNavy,
              );
            } else if (state is AddBasketErrorState) {
              CustomSnackbar.showSnack(
                context,
                state.exeption.message,
                Colors.white,
                LightThemeColors.deepNavy,
              );
            }
          });

          return basketBloc;
        },
        child: Scaffold(
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notif) {
              setState(() {
                if (notif.direction == ScrollDirection.forward) {
                  isFabVisable = true;
                }
                if (notif.direction == ScrollDirection.reverse) {
                  isFabVisable = false;
                }
              });
              return true;
            },
            child: CustomScrollView(
              physics: defaultPhysics,
              slivers: [
                SliverAppBar(
                  leading: const AppBarIcon(),
                  expandedHeight: DeviseSize.getHeight(context) / 3,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: CachedImage(
                    imageUrl: widget.product.image,
                    radius: 12,
                  ),
                  foregroundColor: LightThemeColors.deepNavy,
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (favoriteManager.isFavorite(widget.product)) {
                            favoriteManager.deleteFavorite(widget.product);
                          } else {
                            favoriteManager.addFavorite(widget.product);
                          }
                        });
                      },
                      icon: Icon(
                        favoriteManager.isFavorite(widget.product)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: LightThemeColors.purpule,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.priceFormatter(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                                Text(
                                  widget.product.price.priceFormatter(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: DeviseSize.getHeight(context) / 25),
                        const Text(
                          'توضیحات محصول',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: DeviseSize.getHeight(context) / 85),
                        const Text(
                            'این کتونی کاملا برای دویدن و راه رفتن مناسب است و تقریبا هیچ فشار مخربی را به پا و زانوهایتان انتقال نمیدهد'),
                        SizedBox(height: DeviseSize.getHeight(context) / 45),
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: Padding(
            padding:
                EdgeInsets.only(bottom: DeviseSize.getHeight(context) / 12),
            child: Visibility(
              visible: isFabVisable,
              child: BlocBuilder<AddBasketBloc, AddBasketState>(
                builder: (context, state) {
                  return FloatingActionButton(
                    backgroundColor: LightThemeColors.deepNavy,
                    onPressed: () {
                      BlocProvider.of<AddBasketBloc>(context).add(
                        AddBasketButtonPressed(widget.product.id),
                      );
                    },
                    child: state is AddBasketLoadingState
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : Image.asset(
                            'assets/images/cart.png',
                            color: Colors.white,
                            height: 40,
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
