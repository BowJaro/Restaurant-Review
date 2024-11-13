class MiniTopicModel {
  final int id;
  final String name;

  MiniTopicModel({required this.id, required this.name});

  factory MiniTopicModel.fromMap(Map<String, dynamic> map) {
    return MiniTopicModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }
}
