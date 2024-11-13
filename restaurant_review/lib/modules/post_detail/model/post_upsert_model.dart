class PostUpsertModel {
  final int? id;
  final int topicId;
  final String name;
  final int? metadataId;
  final String content;
  final List<String> hashtagList;
  final List<dynamic> imageList;
  final String profileId;
  final int? restaurantId;

  PostUpsertModel(
      {required this.id,
      required this.topicId,
      required this.name,
      required this.metadataId,
      required this.content,
      required this.hashtagList,
      required this.imageList,
      required this.profileId,
      required this.restaurantId});
}
