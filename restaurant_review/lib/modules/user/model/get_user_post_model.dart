import 'package:get/get.dart';

class UserAndPostsModel {
  final UserModel user;
  final List<PostModel> postList;

  UserAndPostsModel({
    required this.user,
    required this.postList,
  });

  factory UserAndPostsModel.fromMap(Map<String, dynamic> map) {
    return UserAndPostsModel(
      user: UserModel.fromMap(map['user']),
      postList: map['post_list'] == null
          ? []
          : (map['post_list'] as List)
              .map((post) => PostModel.fromMap(post))
              .toList(),
    );
  }
}

class UserModel {
  final String id;
  final String? name;
  final String username;
  final String permission;
  final String? avatarUrl;
  final String biography;
  final DateTime joinDate;
  final RxBool isFollowed;
  final int numberOfFollowers;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.permission,
    required this.avatarUrl,
    required this.biography,
    required this.joinDate,
    required this.isFollowed,
    required this.numberOfFollowers,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      permission: map['permission'],
      avatarUrl: map['avatar_url'],
      biography: map['biography'],
      joinDate: map['join_date'] != null
          ? DateTime.parse(map['join_date'])
          : DateTime.now(),
      isFollowed: map['is_followed'] == true ? true.obs : false.obs,
      numberOfFollowers: map['followers'],
    );
  }
}

class PostModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final int viewCount;
  final String imageUrl;
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
