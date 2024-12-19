import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/rate.dart';

class PostPageModel {
  int id;
  String title;
  String topic;
  List<String> hashtags;
  String username;
  List<RateModel> rateList;
  String userId;
  String? avatarUrl;
  DateTime createdAt;
  RxBool isSaved;
  RxBool isLike;
  RxBool isDislike;
  int likeCount;
  double rateAverage;
  int commentCount;
  int dislikeCount;
  String content;
  int? restaurantId;
  String? restaurantName;
  String? restaurantImage;
  List<String> mediaUrls;

  PostPageModel({
    required this.id,
    required this.title,
    required this.topic,
    required this.isLike,
    required this.hashtags,
    required this.isSaved,
    required this.username,
    required this.rateList,
    required this.userId,
    required this.avatarUrl,
    required this.createdAt,
    required this.isDislike,
    required this.likeCount,
    required this.rateAverage,
    required this.commentCount,
    required this.dislikeCount,
    required this.content,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.mediaUrls,
  });

  factory PostPageModel.fromMap(Map<String, dynamic> map) {
    return PostPageModel(
      id: map['id'],
      title: map['title'],
      topic: map['topic'],
      hashtags:
          map['hashtags'] == null ? [] : List<String>.from(map['hashtags']),
      username: map['username'],
      rateList: map['rate_list'] == null
          ? []
          : List<RateModel>.from(
              map['rate_list'].map((e) => RateModel.fromMap(e))),
      userId: map['user_id'],
      avatarUrl: map['user_avatar'],
      createdAt:
          map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      isLike: map['is_like'] == true ? true.obs : false.obs,
      isSaved: map['is_saved'] == true ? true.obs : false.obs,
      isDislike: map['is_dislike'] == true ? true.obs : false.obs,
      likeCount: map['like_count'],
      rateAverage: map['rate_average'] ?? 0.0,
      commentCount: map['comment_count'],
      dislikeCount: map['dislike_count'],
      content: map['content'],
      restaurantId: map['restaurant_id'],
      restaurantName: map['restaurant_name'],
      restaurantImage: map['restaurant_avatar'],
      mediaUrls:
          map['media_urls'] == null ? [] : List<String>.from(map['media_urls']),
    );
  }
}
