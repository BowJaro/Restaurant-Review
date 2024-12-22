import 'package:supabase_flutter/supabase_flutter.dart';

class MyPostProvider {
  final SupabaseClient supabase;

  MyPostProvider(this.supabase);

  Future<dynamic> getUserPosts(String profileId) async {
    try {
      final response = await supabase.rpc('get_user_with_posts', params: {
        'p_profile_id': profileId,
      });
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching user posts: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching user posts: $error=========');
      return null;
    }
  }

  Future<void> removePost(int id) async {
    try {
      await supabase.from('post').delete().eq('id', id);
    } on PostgrestException catch (error) {
      print('=========Error removing post: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error removing post: $error=========');
    }
  }
}
