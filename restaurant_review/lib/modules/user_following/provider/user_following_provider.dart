import 'package:supabase_flutter/supabase_flutter.dart';

class UserFollowingProvider {
  final SupabaseClient supabase;

  UserFollowingProvider(this.supabase);

  Future<dynamic> getFollowing(String profileId) async {
    try {
      final response = await supabase
          .rpc("get_following", params: {"p_profile_id": profileId});
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching following: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching following: $error=========');
      return null;
    }
  }

  Future<void> removeFollowing(
      String profileId, String source, String type) async {
    try {
      await supabase.rpc('remove_following', params: {
        'p_profile_id': profileId,
        'p_source': source,
        'p_type': type,
      });
    } on PostgrestException catch (error) {
      print('=========Error removing following: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error removing following: $error=========');
    }
  }
}
