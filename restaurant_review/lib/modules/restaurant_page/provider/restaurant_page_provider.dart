import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantPageProvider {
  final SupabaseClient supabase;

  RestaurantPageProvider(this.supabase);

  Future<dynamic> getRestaurantAndPosts(
      int restaurantId, String profileId) async {
    try {
      final response = await supabase.rpc('get_restaurant_and_posts', params: {
        'p_restaurant_id': restaurantId,
        'p_profile_id': profileId,
      });
      return response;
    } on PostgrestException catch (error) {
      print('Error fetching restaurant and posts: ${error.message}');
      return null;
    } catch (error) {
      print('Unknown error fetching restaurant and posts: $error');
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
