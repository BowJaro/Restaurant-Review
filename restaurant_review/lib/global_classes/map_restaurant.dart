class MapRestaurantModel {
  final int id;
  final String imageUrl;
  final String name;
  final double rateAverage;
  final double latitude;
  final double longitude;

  MapRestaurantModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.rateAverage,
    required this.latitude,
    required this.longitude,
  });

  factory MapRestaurantModel.fromMap(Map<String, dynamic> map) {
    return MapRestaurantModel(
      id: map['id'],
      imageUrl: map['image_url'],
      name: map['name'],
      rateAverage: map['rate_average'] != null
          ? double.parse(map['rate_average'].toString())
          : 0.0,
      latitude: map['latitude'] * 1.0,
      longitude: map['longitude'] * 1.0,
    );
  }
}
