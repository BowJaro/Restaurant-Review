class MenuItem {
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      name: map['name'],
      description: map['description'] ?? "",
      price: double.parse(map['price']?.toString() ?? "0"),
      imageUrl: map['image_url'],
    );
  }
}
