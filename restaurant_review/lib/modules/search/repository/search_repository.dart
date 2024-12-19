import '../provider/search_provider.dart';

class SearchRepository {
  final SearchProvider provider;

  SearchRepository(this.provider);

  Future<dynamic> searchByKeyword(
      String filterType, String keyword, String userId) async {
    return await provider.searchByKeyword(filterType, keyword, userId);
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
