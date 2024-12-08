import 'package:supabase_flutter/supabase_flutter.dart';

class FeedProvider {
  final SupabaseClient supabase;

  FeedProvider(this.supabase);

  Future<dynamic> getListFollowingPost(String userId, int limit) async {
    try {
      final response = await supabase.rpc("get_all_following_post_details",
          params: {"p_user_id": userId, "p_quality_post_per_user": limit});
      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching following post details: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching following post details: $error=========');
      return null;
    }
  }

  Future<dynamic> getNewestPost(int limit, String userId) async {
    try {
      final response = await supabase.rpc("get_newest_post_details",
          params: {"p_quantity": limit, "p_user_id": userId});

      print('this is response: ${response}');

      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching newest post details: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching newest post details: $error=========');
      return null;
    }
  }

  Future<void> insertFollowingPost(String userId, String postId) async {
    try {
      await supabase
          .from('following')
          .insert({'profile_id': userId, 'source': postId, 'type': 'post'});
    } on PostgrestException catch (error) {
      print(
          '=========Error inserting following post: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error inserting following post: $error=========');
    }
  }

  Future<void> deleteFollowingPost(String userId, String postId) async {
    try {
      await supabase
          .from('following')
          .delete()
          .eq('profile_id', userId)
          .eq('source', postId)
          .eq('type', 'post');
    } on PostgrestException catch (error) {
      print(
          '=========Error deleting following post: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error deleting following post: $error=========');
    }
  }

  Future<void> upsertReaction(
      String userId, String reactionType, int postId) async {
    try {
      await supabase.rpc(
        "upsert_reaction_post",
        params: {
          'p_user_id': userId,
          'p_reaction_type': reactionType,
          'p_post_id': postId,
        },
      );
    } on PostgrestException catch (e) {
      print('Error upserting reaction: ${e.message}');
    } catch (e) {
      print('Unknown error upserting reaction: $e');
    }
  }

  Future<void> deleteReaction(String userId, int postId) async {
    try {
      await supabase
          .from('reaction')
          .delete()
          .eq('profile_id', userId)
          .eq('source', postId)
          .eq('type', 'post');
    } on PostgrestException catch (error) {
      print(
          '=========Error deleting following post: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error deleting following post: $error=========');
    }
  }
}
