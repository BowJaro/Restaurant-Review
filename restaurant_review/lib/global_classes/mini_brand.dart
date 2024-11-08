class MiniBrandModel {
  final int id;
  final String name;

  MiniBrandModel({required this.id, required this.name});

  factory MiniBrandModel.fromMap(Map<String, dynamic> map) {
    return MiniBrandModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}
