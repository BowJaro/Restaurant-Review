import 'package:restaurant_review/global_classes/mini_brand.dart';
import 'package:restaurant_review/global_classes/mini_restaurant_category.dart';

class RestaurantGetModel {
  final int id;
  final String name;
  final int brandId;
  final int restaurantCategoryId;
  final int metadataId;
  final String description;
  final List<String> hashtagList;
  final List<String> imageList;
  final int avatarId;
  final String avatar;
  final int addressId;
  final String province;
  final String district;
  final String ward;
  final String street;
  final int locationId;
  final double latitude;
  final double longitude;
  final List<MiniBrandModel> brandList;
  final List<MiniRestaurantCategoryModel> restaurantCategoryList;

  RestaurantGetModel(
      {required this.id,
      required this.name,
      required this.brandId,
      required this.restaurantCategoryId,
      required this.metadataId,
      required this.description,
      required this.hashtagList,
      required this.imageList,
      required this.avatarId,
      required this.avatar,
      required this.addressId,
      required this.province,
      required this.district,
      required this.ward,
      required this.street,
      required this.locationId,
      required this.latitude,
      required this.longitude,
      required this.brandList,
      required this.restaurantCategoryList});

  factory RestaurantGetModel.fromMap(Map<String, dynamic> map) {
    return RestaurantGetModel(
      id: map['id'],
      name: map['name'],
      brandId: map['brand_id'],
      restaurantCategoryId: map['restaurant_category_id'],
      metadataId: map['metadata_id'],
      description: map['description'],
      hashtagList: List<String>.from(map['hashtag_list']),
      imageList: List<String>.from(map['image_list']),
      avatarId: map['avatar_id'],
      avatar: map['avatar'],
      addressId: map['address_id'],
      province: map['province'],
      district: map['district'],
      ward: map['ward'],
      street: map['street'],
      locationId: map['location_id'],
      latitude: map['latitude'] * 1.0,
      longitude: map['longitude'] * 1.0,
      brandList: (map['brand_list'] as List<dynamic>)
          .map((item) => MiniBrandModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      restaurantCategoryList: (map['restaurant_category_list'] as List<dynamic>)
          .map((item) =>
              MiniRestaurantCategoryModel.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'brand_id': brandId,
        'restaurant_category_id': restaurantCategoryId,
        'metadata_id': metadataId,
        'description': description,
        'hashtag_list': hashtagList,
        'image_list': imageList,
        'avatar_id': avatarId,
        'avatar': avatar,
        'address_id': addressId,
        'province': province,
        'district': district,
        'ward': ward,
        'street': street,
        'location_id': locationId,
        'latitude': latitude,
        'longitude': longitude,
        'brand_list': brandList,
        'restaurant_category_list': restaurantCategoryList,
      };
}
