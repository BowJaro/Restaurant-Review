import 'package:get/get.dart';

class RestaurantCardModel {
  final int id;
  final String provinceId;
  final String districtId;
  final String wardId;
  final String street;
  final double rateAverage;
  final String name;
  final String imageUrl;
  final List<String> hashtagList;
  RxBool isFollowed;

  RestaurantCardModel({
    required this.id,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.street,
    required this.rateAverage,
    required this.name,
    required this.imageUrl,
    required this.hashtagList,
    required this.isFollowed,
  });

  factory RestaurantCardModel.fromJson(Map<String, dynamic> json) {
    return RestaurantCardModel(
      id: json['id'],
      provinceId: json['province_id'],
      districtId: json['district_id'],
      wardId: json['ward_id'],
      street: json['street'],
      rateAverage: json['rate_average']?.toDouble() ?? 0.0,
      name: json['name'],
      imageUrl: json['image_url'],
      hashtagList: List<String>.from(json['hashtag_list']),
      isFollowed: (json['is_followed'] as bool).obs,
    );
  }
}
