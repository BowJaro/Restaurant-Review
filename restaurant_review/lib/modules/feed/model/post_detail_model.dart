import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/rate.dart';

class PostDetail {
  final int id;
  final String? username;
  final String? avatarUrl;
  final String? restaurantName;
  final String? restaurantImage;
  final String createdAt;
  final String title;
  final String topic;
  final String metadataText;
  final List<String>? metadataImageList;
  final List<String>? hashtags;
  final double? rateAverage;
  final List<RateModel>? rateList;
  final RxBool isSaved;
  final RxBool isLike;
  final RxBool isDislike;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;

  PostDetail({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.restaurantName,
    required this.restaurantImage,
    required this.createdAt,
    required this.title,
    required this.topic,
    required this.metadataText,
    required this.metadataImageList,
    required this.hashtags,
    required this.rateAverage,
    required this.rateList,
    required this.isSaved,
    required this.isLike,
    required this.isDislike,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
  });

  factory PostDetail.fromMap(Map<String, dynamic> map) {
    return PostDetail(
      id: map['id'],
      username: map['username'],
      avatarUrl: map['avatar_url'],
      restaurantName: map['restaurant_name'],
      restaurantImage: map['restaurant_image'],
      createdAt: map['created_at'],
      title: map['title'],
      topic: map['topic'],
      metadataText: map['metadata_text'],
      metadataImageList: List<String>.from(map['metadata_image_list'] ?? []),
      hashtags: List<String>.from(map['hashtags'] ?? []),
      rateAverage: map['rate_average'] != null
          ? double.parse(map['rate_average'].toString())
          : 0.0,
      rateList: List<RateModel>.from((map['rate_list'] ?? [])
          .map((x) => RateModel.fromMap(x as Map<String, dynamic>))),
      isSaved: (map['is_saved'] as bool).obs,
      isLike: (map['is_like'] as bool).obs,
      isDislike: (map['is_dislike'] as bool).obs,
      likeCount: map['like_count'],
      dislikeCount: map['dislike_count'],
      commentCount: map['comment_count'],
    );
  }
}
