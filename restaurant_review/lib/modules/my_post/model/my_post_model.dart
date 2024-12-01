class MyPostModel {
  int postId;
  String name;
  String? imageUrl;
  DateTime createdAt;
  int views;
  String topic;

  MyPostModel({
    required this.postId,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.views,
    required this.topic,
  });

  factory MyPostModel.fromMap(Map<String, dynamic> map) => MyPostModel(
        postId: map["post_id"],
        name: map["name"],
        imageUrl: map["image_url"],
        createdAt:
            map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
        views: map["views"],
        topic: map["topic"],
      );
}
