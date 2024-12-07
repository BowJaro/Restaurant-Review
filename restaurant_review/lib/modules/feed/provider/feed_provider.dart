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
}
