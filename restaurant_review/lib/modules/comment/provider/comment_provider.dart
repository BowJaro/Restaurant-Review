import 'package:supabase_flutter/supabase_flutter.dart';

class CommentProvider {
  final SupabaseClient supabase;

  CommentProvider(this.supabase);

  Future<dynamic> getComments(int postId, String profileId) async {
    try {
      final response = await supabase.rpc("get_comments_and_replies", params: {
        'p_post_id': postId,
        'p_user_id': profileId,
      });
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching comments: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching comments: $error=========');
      return null;
    }
  }

  Future<dynamic> upsertReaction(
      {required int? reactionId,
      required int? source,
      required String content,
      required String profileId}) async {
    try {
      final response = await supabase.rpc("upsert_reaction", params: {
        'p_reaction_id': reactionId,
        'p_source': source,
        'p_content': content,
        'p_type': 'comment',
        'p_user_id': profileId
      });
      print(
          '=========Upsert reaction: $reactionId, $source, $content, $profileId=========');
      print('=========Response: ${response.toString()}=========');

      return response;
    } on PostgrestException catch (error) {
      print('=========Error upsert reaction: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error upsert reaction: $error=========');
      return null;
    }
  }

  Future<void> insertComment(
      {required String content,
      required int source,
      required String type,
      required String profileId}) async {
    try {
      await supabase.rpc('insert_comment', params: {
        'p_content': content,
        'p_source': source,
        'p_type': type,
        'p_profile_id': profileId
      });
    } on PostgrestException catch (error) {
      print('=========Error inserting comment: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error inserting comment: $error=========');
    }
  }

  Future<void> removeComment(int commentId) async {
    try {
      await supabase.rpc('remove_comment', params: {'p_id': commentId});
    } on PostgrestException catch (error) {
      print('=========Error removing comment: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error removing comment: $error=========');
    }
  }
}
