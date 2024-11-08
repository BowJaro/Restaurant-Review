class MiniRestaurantCategoryModel {
  final int id;
  final String name;

  MiniRestaurantCategoryModel({required this.id, required this.name});

  factory MiniRestaurantCategoryModel.fromMap(Map<String, dynamic> map) {
    return MiniRestaurantCategoryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}
