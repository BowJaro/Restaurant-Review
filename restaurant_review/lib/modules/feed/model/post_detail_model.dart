import 'package:restaurant_review/global_classes/rate.dart';

class PostDetail {
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

  PostDetail({
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
  });

  factory PostDetail.fromMap(Map<String, dynamic> map) {
    return PostDetail(
      username: map['username'],
      avatarUrl: map['avatar_url'],
      restaurantName: map['restaurant_name'],
      restaurantImage: map['restaurant_image'],
      createdAt: map['created_at'],
      title: map['title'],
      topic: map['topic'],
      metadataText: map['metadata_text'],
      metadataImageList: List<String>.from(map['metadata_image_list']),
      hashtags: List<String>.from(map['hashtags']),
      rateAverage: map['rate_average'] as double,
      rateList: List<RateModel>.from(map['rate_list']
          .map((x) => RateModel.fromMap(x as Map<String, dynamic>))),
    );
  }
}
