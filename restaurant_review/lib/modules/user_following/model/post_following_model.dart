class PostFollowingModel {
  final int id;
  final String name;
  final String? imageUrl;
  final String? author;
  final int viewCount;
  final String topic;

  PostFollowingModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.author,
    required this.viewCount,
    required this.topic,
  });

  factory PostFollowingModel.fromMap(Map<String, dynamic> map) {
    return PostFollowingModel(
      id: int.parse(map['id']),
      name: map['name'],
      imageUrl: map['image_url'],
      author: map['author'],
      viewCount: map['view_count'],
      topic: map['topic'],
    );
  }
}
