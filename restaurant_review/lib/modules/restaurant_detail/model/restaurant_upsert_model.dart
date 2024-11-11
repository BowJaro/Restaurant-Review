class RestaurantUpsertModel {
  final int? id;
  final String name;
  final int metadataId;
  final String description;
  final int restaurantCategoryId;
  final int brandId;
  final List<String> hashtagList;
  final List<dynamic> imageList;
  final int avatarId;
  final dynamic avatar;
  final int addressId;
  final String province;
  final String district;
  final String ward;
  final String street;
  final int locationId;
  final double latitude;
  final double longitude;

  RestaurantUpsertModel(
      {required this.id,
      required this.name,
      required this.metadataId,
      required this.description,
      required this.restaurantCategoryId,
      required this.brandId,
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
      required this.longitude});

  factory RestaurantUpsertModel.fromJson(Map<String, dynamic> json) {
    return RestaurantUpsertModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      metadataId: json['metadata_id'] as int,
      description: json['description'] as String,
      restaurantCategoryId: json['restaurant_category_id'] as int,
      brandId: json['brand_id'] as int,
      hashtagList: json['hashtag_list'] as List<String>,
      imageList: json['image_list'] as List<dynamic>,
      avatarId: json['avatar_id'] as int,
      avatar: json['avatar'],
      addressId: json['address_id'] as int,
      province: json['province'] as String,
      district: json['district'] as String,
      ward: json['ward'] as String,
      street: json['street'] as String,
      locationId: json['location_id'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'metadata_id': metadataId,
      'description': description,
      'restaurant_category_id': restaurantCategoryId,
      'brand_id': brandId,
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
    };
  }
}
