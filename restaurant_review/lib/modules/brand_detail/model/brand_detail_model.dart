class BrandDetailModel {
  int? id;
  String name;
  String description;
  dynamic image;

  BrandDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory BrandDetailModel.fromMap(Map<String, dynamic> json) {
    return BrandDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': image,
    };
  }
}
