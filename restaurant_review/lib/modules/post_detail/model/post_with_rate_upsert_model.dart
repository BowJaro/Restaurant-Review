import 'package:restaurant_review/global_classes/rate.dart';

class PostWithRateUpsertModel {
  final int? id;
  final int topicId;
  final String name;
  final int? metadataId;
  final String content;
  final List<String> hashtagList;
  final List<dynamic> imageList;
  final String profileId;
  final int? restaurantId;
  final List<RateModel> rateList;
  final int? rateId;

  PostWithRateUpsertModel(
      {required this.id,
      required this.topicId,
      required this.name,
      required this.metadataId,
      required this.content,
      required this.hashtagList,
      required this.imageList,
      required this.profileId,
      required this.restaurantId,
      required this.rateList,
      required this.rateId});
}
