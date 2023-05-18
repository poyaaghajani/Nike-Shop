import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/default_physics.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/cached_image.dart';
import 'package:nike/core/widgets/custom_buton.dart';
import 'package:nike/core/widgets/loading_widget.dart';
import 'package:nike/features/home_feature/data/model/product.dart';
import 'package:nike/features/home_feature/data/repository/banner.repository.dart';
import 'package:nike/features/home_feature/data/repository/product_repository.dart';
import 'package:nike/features/home_feature/presentation/bloc/home/home_bloc.dart';
import 'package:nike/features/home_feature/presentation/screens/all_products_screen.dart';
import 'package:nike/features/home_feature/presentation/widgets/products_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
          bannerRepository,
          productRepository,
        );
        homeBloc.add(HomeRequest());

        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return const LoadingWidget();
              }
              if (state is HomeSuccessState) {
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      8, 8, 8, DeviseSize.getHeight(context) / 9),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Image.asset(
                          'assets/images/nike_logo.png',
                          height: 34,
                        );
                      case 2:
                        // banners
                        return homeBanners(context, pageController, state);
                      case 3:
                        return ProductsList(
                          products: state.latestProducts,
                          title: 'جدیدترین',
                          ontap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AllProductsScreen(
                                    sort: ProductSort.lastest,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      case 4:
                        return ProductsList(
                          products: state.popularProducts,
                          title: 'پر بازدیدترین',
                          ontap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AllProductsScreen(
                                    sort: ProductSort.popular,
                                  );
                                },
                              ),
                            );
                          },
                        );

                      default:
                        return Container();
                    }
                  },
                );
              }
              if (state is HomeErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.exeption.message),
                      SizedBox(height: DeviseSize.getHeight(context) / 85),
                      CustomButton(
                        onPressed: () {
                          BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                        },
                        text: 'تلاش دوباره',
                        color: LightThemeColors.deepNavy,
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  // banners
  Container homeBanners(
    BuildContext context,
    PageController pageController,
    HomeSuccessState state,
  ) {
    return Container(
      margin: EdgeInsets.only(top: DeviseSize.getHeight(context) / 40),
      height: DeviseSize.getHeight(context) / 3.8,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            physics: defaultPhysics,
            scrollDirection: Axis.horizontal,
            itemCount: state.banners.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: CachedImage(
                    fit: BoxFit.fill,
                    radius: 12,
                    imageUrl: state.banners[index].image,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SmoothPageIndicator(
              controller: pageController,
              count: state.banners.length,
              effect: const ExpandingDotsEffect(
                dotWidth: 12,
                dotHeight: 7,
                dotColor: LightThemeColors.secondaryTextColor,
                activeDotColor: LightThemeColors.deepNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
