import 'package:restaurant_review/global_classes/mini_restaurant.dart';
import 'package:restaurant_review/global_classes/mini_topic.dart';
import 'package:restaurant_review/global_classes/rate.dart';

class DataForNewPostModel {
  final List<MiniTopicModel> topicList;
  final List<MiniRestaurantModel> restaurantList;
  final List<RateModel> rateList;

  DataForNewPostModel(
      {required this.topicList,
      required this.restaurantList,
      required this.rateList});

  factory DataForNewPostModel.fromMap(Map<String, dynamic> map) {
    final topicList = List<MiniTopicModel>.from(
        map['topic'].map((x) => MiniTopicModel.fromMap(x)));
    final restaurantList = List<MiniRestaurantModel>.from(
        map['restaurant'].map((x) => MiniRestaurantModel.fromMap(x)));
    final rateList =
        List<RateModel>.from(map['rate'].map((x) => RateModel.fromMap(x)));

    return DataForNewPostModel(
      topicList: topicList,
      restaurantList: restaurantList,
      rateList: rateList,
    );
  }
}
