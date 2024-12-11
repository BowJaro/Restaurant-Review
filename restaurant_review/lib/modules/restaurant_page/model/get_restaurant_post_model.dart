import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/mini_post_card.dart';

class RestaurantAndPostsModel {
  final RestaurantModel restaurant;
  final List<PostModel> postList;

  RestaurantAndPostsModel({
    required this.restaurant,
    required this.postList,
  });

  factory RestaurantAndPostsModel.fromMap(Map<String, dynamic> map) {
    return RestaurantAndPostsModel(
      restaurant: RestaurantModel.fromMap(map['restaurant']),
      postList: map['post_list'] == null
          ? []
          : (map['post_list'] as List)
              .map((post) => PostModel.fromMap(post))
              .toList(),
    );
  }
}

class RestaurantModel {
  final int id;
  final String name;
  final int brandId;
  final String brandName;
  final String restaurantCategoryName;
  final String imageUrl;
  final String provinceId;
  final String districtId;
  final String wardId;
  final String street;
  final double longitude;
  final double latitude;
  final List<String> hashtagList;
  final List<String> imageList;
  final double averageRate;
  final String description;
  final RxBool isFollowed;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.brandId,
    required this.brandName,
    required this.restaurantCategoryName,
    required this.imageUrl,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.street,
    required this.longitude,
    required this.latitude,
    required this.hashtagList,
    required this.imageList,
    required this.averageRate,
    required this.description,
    required this.isFollowed,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'],
      name: map['name'],
      brandId: map['brand_id'],
      brandName: map['brand_name'],
      restaurantCategoryName: map['restaurant_category_name'],
      imageUrl: map['image_url'],
      provinceId: map['province_id'],
      districtId: map['district_id'],
      wardId: map['ward_id'],
      street: map['street'],
      longitude:
          map['longitude'] != null ? (map['longitude'] as num).toDouble() : 0.0,
      latitude:
          map['latitude'] != null ? (map['latitude'] as num).toDouble() : 0.0,
      hashtagList: (map['hashtag_list'] as List?)?.cast<String>() ?? [],
      imageList: (map['image_list'] as List?)?.cast<String>() ?? [],
      averageRate: map['average_rate'] != null
          ? (map['average_rate'] as num).toDouble()
          : 0.0,
      description: map['description'],
      isFollowed: map['is_followed'] == true ? true.obs : false.obs,
    );
  }
}
