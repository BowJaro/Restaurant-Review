class UserFollowerModel {
  final String id;
  final String? imageUrl;
  final String? name;
  final String username;
  final DateTime joinDate;

  UserFollowerModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.username,
    required this.joinDate,
  });

  factory UserFollowerModel.fromMap(Map<String, dynamic> map) {
    return UserFollowerModel(
      id: map['id'],
      imageUrl: map['image_url'],
      name: map['name'],
      username: map['username'],
      joinDate: DateTime.parse(map['join_date']),
    );
  }
}
