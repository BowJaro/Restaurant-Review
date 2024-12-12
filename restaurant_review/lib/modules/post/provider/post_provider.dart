import 'package:supabase_flutter/supabase_flutter.dart';

class PostProvider {
  final SupabaseClient supabase;

  PostProvider(this.supabase);

  /// Call the stored procedure to get post page
  Future<dynamic> getPostPage(int postId, String profileId) async {
    try {
      final response = await supabase.rpc('get_post_page', params: {
        'p_post_id': postId,
        'p_profile_id': profileId,
      });
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching post page: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching post page: $error=========');
      return null;
    }
  }

  /// Call the stored procedure to toggle following
  Future<void> toggleFollowing(
    String profileId,
    String source,
    String type,
  ) async {
    try {
      await supabase.rpc('toggle_following', params: {
        'p_profile_id': profileId,
        'p_source': source,
        'p_type': type,
      });
    } on PostgrestException catch (error) {
      print('=========Error toggling following: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error toggling following: $error=========');
    }
  }

  /// Call the stored procedure to upsert a reaction
  Future<int> upsertReaction(
    int? reactionId,
    int source,
    String content,
    String profileId,
    String type,
  ) async {
    try {
      final response = await supabase.rpc('upsert_reaction', params: {
        'p_reaction_id': reactionId,
        'p_source': source,
        'p_content': content,
        'p_user_id': profileId,
        'p_type': type,
      });
      return response as int;
    } on PostgrestException catch (error) {
      print('=========Error upserting reaction: ${error.message}=========');
      return 0;
    } catch (error) {
      print('=========Unknown error upserting reaction: $error=========');
      return 0;
    }
  }
}
