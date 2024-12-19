class MiniUserModel {
  String? id;
  String? username;
  String? avatarUrl;

  MiniUserModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
  });

  factory MiniUserModel.fromMap(Map<String, dynamic> json) {
    return MiniUserModel(
      id: json['id'] ?? "",
      username: json['username'] ?? "",
      avatarUrl: json['avatar_url'] ?? "",
    );
  }
}
