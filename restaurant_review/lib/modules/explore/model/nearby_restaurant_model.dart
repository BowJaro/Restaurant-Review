class NearbyRestaurantModel {
  final int id;
  final String imageUrl;
  final String name;
  final double rateAverage;
  final String provinceId;
  final String districtId;
  final String wardId;
  final String street;
  final double distance;

  NearbyRestaurantModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.rateAverage,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.street,
    required this.distance,
  });

  factory NearbyRestaurantModel.fromMap(Map<String, dynamic> map) {
    return NearbyRestaurantModel(
      id: map['id'],
      imageUrl: map['image_url'],
      name: map['name'],
      rateAverage: map['rate_average'] != null
          ? double.parse(map['rate_average'].toString())
          : 0.0,
      provinceId: map['province_id'],
      districtId: map['district_id'],
      wardId: map['ward_id'],
      street: map['street'],
      distance: map['distance'] != null
          ? double.parse(map['distance'].toString())
          : 0.0,
    );
  }
}
