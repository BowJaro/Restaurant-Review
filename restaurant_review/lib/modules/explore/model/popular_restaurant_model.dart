class PopularRestaurantModel {
  final int id;
  final String imageUrl;
  final String name;
  final double rateAverage;
  final String provinceId;
  final String districtId;
  final String wardId;
  final String street;

  PopularRestaurantModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.rateAverage,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.street,
  });

  factory PopularRestaurantModel.fromMap(Map<String, dynamic> map) {
    return PopularRestaurantModel(
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
    );
  }
}
