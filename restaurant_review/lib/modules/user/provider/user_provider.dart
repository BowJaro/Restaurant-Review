import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider {
  final SupabaseClient supabase;

  UserProvider(this.supabase);

  Future<dynamic> getUserAndPosts(
      String targetProfileId, String myProfileId) async {
    try {
      final response = await supabase.rpc('get_user_and_posts', params: {
        'p_target_profile_id': targetProfileId,
        'p_my_profile_id': myProfileId
      });
      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching user and posts: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching user and posts: $error=========');
      return null;
    }
  }

  Future<void> toggleFollowing(
      String source, String type, String profileId) async {
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
}
