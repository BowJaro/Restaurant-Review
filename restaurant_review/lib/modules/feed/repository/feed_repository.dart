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
}
