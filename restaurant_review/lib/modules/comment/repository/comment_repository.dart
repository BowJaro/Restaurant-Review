import '../provider/comment_provider.dart';

class CommentRepository {
  final CommentProvider provider;

  CommentRepository(this.provider);

  Future<dynamic> getComments(int postId, String profileId) async {
    return await provider.getComments(postId, profileId);
  }

  Future<dynamic> upsertReaction(
      {required int? reactionId,
      required int? source,
      required String content,
      required String profileId}) async {
    return await provider.upsertReaction(
        reactionId: reactionId,
        source: source,
        content: content,
        profileId: profileId);
  }

  Future<void> insertComment(
      {required String content,
      required int source,
      required String type,
      required String profileId}) async {
    await provider.insertComment(
        content: content, source: source, type: type, profileId: profileId);
  }

  Future<void> removeComment(int commentId) async {
    await provider.removeComment(commentId);
  }
}
