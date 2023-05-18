import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/utils/view_type.dart';
import 'package:nike/core/widgets/app_bar_icon.dart';
import 'package:nike/core/widgets/custom_state.dart';
import 'package:nike/core/widgets/loading_widget.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/home_feature/data/repository/product_repository.dart';
import 'package:nike/features/home_feature/presentation/bloc/all_products/all_products_bloc.dart';
import 'package:nike/features/home_feature/presentation/widgets/product_item.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key, required this.sort});

  final int sort;

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  AllProductsBloc? productBloc;

  // show items type
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    productBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const AppBarIcon(),
          foregroundColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: LightThemeColors.backgroundColor,
          centerTitle: true,
          title: Text(
            'کفش های ورزشی',
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
          ),
        ),
        body: BlocProvider<AllProductsBloc>(
          create: (context) {
            productBloc = AllProductsBloc(productRepository)
              ..add(AllProductsRequest(widget.sort));

            return productBloc!;
          },
          child: BlocBuilder<AllProductsBloc, AllProductsState>(
            builder: (context, state) {
              if (state is AllProductsLoadingState) {
                return const LoadingWidget();
              }

              if (state is AllProductsSuccessState) {
                return Column(
                  children: [
                    // header
                    header(context, state),

                    // main content
                    mainContent(context, state),
                  ],
                );
              }

              if (state is AllProductsErrorState) {
                return CustomState(
                  text: state.exeption.message,
                  image: 'assets/images/no_data.svg',
                  onTap: () {},
                  buttonText: 'تلاش دوباره',
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Container header(BuildContext context, AllProductsSuccessState state) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        color: LightThemeColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // bottom sheet
                bottomSheet(context, state);
              },
              child: const Icon(
                CupertinoIcons.sort_down,
                size: 30,
                color: LightThemeColors.navy,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرتب سازی',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  ProductSort.names[state.sort],
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: VerticalDivider(
                width: 1,
                color: Colors.grey,
              ),
            ),
            InkWell(
              onTap: () {
                setState(
                  () {
                    (viewType == ViewType.grid)
                        ? viewType = ViewType.list
                        : viewType = ViewType.grid;
                  },
                );
              },
              child: const Icon(
                CupertinoIcons.square_grid_2x2,
                size: 26,
                color: LightThemeColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // bottom sheet
  Future<dynamic> bottomSheet(
      BuildContext context, AllProductsSuccessState state) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: DeviseSize.getHeight(context) / 3.2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'مرتب سازی بر اساس',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18),
                ),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.builder(
                      itemCount: state.sortNames.length,
                      itemBuilder: (context, index) {
                        final selectedSort = state.sort;
                        return InkWell(
                          onTap: () {
                            productBloc!.add(AllProductsRequest(index));
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            child: Text(
                              state.sortNames[index],
                              style: TextStyle(
                                color: (index == selectedSort)
                                    ? LightThemeColors.primaryColor
                                    : LightThemeColors.navy,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // main content
  Expanded mainContent(BuildContext context, AllProductsSuccessState state) {
    return Expanded(
      child: GridView.builder(
        physics: defaultPhysics,
        padding: EdgeInsets.only(
          bottom: DeviseSize.getHeight(context) / 8,
          top: 8,
        ),
        itemCount: state.products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: viewType == ViewType.grid ? 2 : 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 20,
          childAspectRatio: viewType == ViewType.grid ? 0.55 : 0.65,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: ProductItem(
              products: state.products[index],
            ),
          );
        },
      ),
    );
  }
}
