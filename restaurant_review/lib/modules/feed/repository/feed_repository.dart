import '../provider/feed_provider.dart';

class FeedRepository {
  final FeedProvider provider;

  FeedRepository(this.provider);

  Future<dynamic> getListFollowingPost(String userId, int limit) async {
    return await provider.getListFollowingPost(userId, limit);
  }

  Future<dynamic> getNewestPost(int limit, String userId) async {
    return await provider.getNewestPost(limit, userId);
  }

  Future<void> insertFollowingPost(String userId, String postId) async {
    return await provider.insertFollowingPost(userId, postId);
  }

  Future<void> deleteFollowingPost(String userId, String postId) async {
    return await provider.deleteFollowingPost(userId, postId);
  }

  Future<void> upsertReaction(
      String userId, String reactionType, int postId) async {
    return await provider.upsertReaction(userId, reactionType, postId);
  }

  Future<void> deleteReaction(String userId, int postId) async {
    return await provider.deleteReaction(userId, postId);
  }
}
