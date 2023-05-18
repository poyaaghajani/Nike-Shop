import 'package:dio/dio.dart';
import 'package:nike/core/utils/validator.dart';
import 'package:nike/features/home_feature/data/model/banner.dart';

abstract class IBannerDatasource {
  Future<List<BannerModel>> getBanners();
}

class BannerRemoteDatasource implements IBannerDatasource {
  final Dio dio;

  BannerRemoteDatasource(this.dio);

  @override
  Future<List<BannerModel>> getBanners() async {
    final response = await dio.get('banner/slider');
    validateResponse(response);

    final List<BannerModel> banners = [];

    for (var element in (response.data as List)) {
      banners.add(BannerModel.fromJson(element));
    }

    return banners;
  }
}
