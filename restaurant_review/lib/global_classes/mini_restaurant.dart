class MiniRestaurantModel {
  final int id;
  final String name;

  MiniRestaurantModel({required this.id, required this.name});

  factory MiniRestaurantModel.fromMap(Map<String, dynamic> map) {
    return MiniRestaurantModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
