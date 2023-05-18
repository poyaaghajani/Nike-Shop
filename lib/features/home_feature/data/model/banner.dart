class BannerModel {
  int id;
  String image;

  BannerModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'];
}
