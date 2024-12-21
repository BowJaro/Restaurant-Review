class PostModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final int viewCount;
  final String? imageUrl;
  final String topic;

  PostModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.viewCount,
    required this.imageUrl,
    required this.topic,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      name: map['name'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      viewCount: map['view_count'],
      imageUrl: map['image_url'],
      topic: map['topic'],
    );
  }
}
