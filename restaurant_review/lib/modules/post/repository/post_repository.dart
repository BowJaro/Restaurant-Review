import '../provider/post_provider.dart';

class PostRepository {
  final PostProvider provider;

  PostRepository(this.provider);

  Future<dynamic> getPostPage(int postId, String profileId) async {
    return await provider.getPostPage(postId, profileId);
  }

  Future<void> toggleFollowing(
      {required String profileId,
      required String source,
      required String type}) async {
    return await provider.toggleFollowing(profileId, source, type);
  }

  Future<int> upsertReaction(
      {required int? reactionId,
      required int source,
      required String content,
      required String profileId}) async {
    return await provider.upsertReaction(
        reactionId, source, content, profileId, 'post');
  }
}
