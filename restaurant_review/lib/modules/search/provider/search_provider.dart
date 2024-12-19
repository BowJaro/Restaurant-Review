import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();

  SearchProvider(this.supabase);

  Future<dynamic> searchByKeyword(
      String filterType, String keyword, String userId) async {
    try {
      final response = await supabase.rpc("search_by_keyword", params: {
        "filter_type": filterType,
        "keyword": keyword,
        "user_id": userId,
      });

      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching nearby restaurant: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching nearby restaurant: $error=========');
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
