import 'package:restaurant_review/global_classes/mini_restaurant.dart';
import 'package:restaurant_review/global_classes/mini_topic.dart';
import 'package:restaurant_review/global_classes/rate.dart';

class GetDataForPostModel {
  final int id;
  final String name;
  final int topicId;
  final List<MiniTopicModel> topicList;
  final int restaurantId;
  final List<MiniRestaurantModel> restaurantList;
  final int rateId;
  final List<RateModel> rateList;
  final int metadataId;
  final String content;
  final List<String> hashtagList;
  final List<String> imageUrlList;

  GetDataForPostModel(
      {required this.id,
      required this.name,
      required this.topicId,
      required this.topicList,
      required this.restaurantId,
      required this.restaurantList,
      required this.rateId,
      required this.rateList,
      required this.metadataId,
      required this.content,
      required this.hashtagList,
      required this.imageUrlList});

  factory GetDataForPostModel.fromMap(Map<String, dynamic> map) {
    final topicList = List<MiniTopicModel>.from(
        map['topic'].map((x) => MiniTopicModel.fromMap(x)));
    final restaurantList = List<MiniRestaurantModel>.from(
        map['restaurant'].map((x) => MiniRestaurantModel.fromMap(x)));
    final rateList = List<RateModel>.from(map['rate'] == null
        ? []
        : map['rate'].map((x) => RateModel.fromMap(x)));
    final hashtagList = map['hashtag_list'] == null
        ? <String>[]
        : List<String>.from(map['hashtag_list'].map((x) => x));
    final imageUrlList = map['image_url_list'] == null
        ? <String>[]
        : List<String>.from(map['image_url_list'].map((x) => x));

    return GetDataForPostModel(
      id: map['id'],
      name: map['name'],
      topicId: map['topic_id'],
      topicList: topicList,
      restaurantId: map['restaurant_id'] ?? 0,
      restaurantList: restaurantList,
      rateId: map['rate_id'] ?? 0,
      rateList: rateList,
      metadataId: map['metadata_id'],
      content: map['content'],
      hashtagList: hashtagList,
      imageUrlList: imageUrlList,
    );
  }
}
