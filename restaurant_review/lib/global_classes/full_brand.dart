class BrandModel {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  BrandModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['image_url'],
    );
  }
}
