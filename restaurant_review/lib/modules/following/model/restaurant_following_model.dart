class RestaurantFollowingModel {
  final int id;
  final String imageUrl;
  final String name;
  final double rateAverage;
  final String provinceId;
  final String districtId;
  final String wardId;
  final String street;
  final String category;

  RestaurantFollowingModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.rateAverage,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.street,
    required this.category,
  });

  factory RestaurantFollowingModel.fromMap(Map<String, dynamic> map) {
    return RestaurantFollowingModel(
      id: int.parse(map['id']),
      imageUrl: map['image_url'],
      name: map['name'],
      rateAverage: map['rate_average'] ?? 0.0,
      provinceId: map['province_id'],
      districtId: map['district_id'],
      wardId: map['ward_id'],
      street: map['street'],
      category: map['category'],
    );
  }
}
