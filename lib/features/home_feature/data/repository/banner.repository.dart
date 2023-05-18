import 'package:nike/core/utils/api_service.dart';
import 'package:nike/features/home_feature/data/datasource/banner_datasource.dart';
import 'package:nike/features/home_feature/data/model/banner.dart';

final bannerRepository = BannerRepository(BannerRemoteDatasource(dio));

abstract class IBannerRepository {
  Future<List<BannerModel>> getBanners();
}

class BannerRepository implements IBannerRepository {
  final IBannerDatasource bannerDatasource;
  BannerRepository(this.bannerDatasource);

  @override
  Future<List<BannerModel>> getBanners() {
    return bannerDatasource.getBanners();
  }
}
