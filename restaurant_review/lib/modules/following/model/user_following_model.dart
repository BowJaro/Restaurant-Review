class UserFollowingModel {
  final String id;
  final String? imageUrl;
  final String? name;
  final String username;
  final DateTime joinDate;

  UserFollowingModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.username,
    required this.joinDate,
  });

  factory UserFollowingModel.fromMap(Map<String, dynamic> map) {
    return UserFollowingModel(
      id: map['id'],
      imageUrl: map['image_url'],
      name: map['name'],
      username: map['username'],
      joinDate: DateTime.parse(map['join_date']),
    );
  }
}
