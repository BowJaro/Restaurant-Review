import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantManagementProvider {
  final SupabaseClient supabase;

  RestaurantManagementProvider(this.supabase);

  /// Call the stored procedure to get user's restaurants
  Future<dynamic> getUserRestaurants(String profileId) async {
    try {
      final response = await supabase
          .rpc('get_user_restaurants', params: {'p_profile_id': profileId});
      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching user restaurants: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching user restaurants: $error=========');
      return null;
    }
  }

  /// Call the stored procedure to delete a row of restaurant table
  Future<void> deleteRestaurant(int id) async {
    try {
      await supabase.from('restaurant').delete().eq('id', id);
    } on PostgrestException catch (error) {
      print('=========Error deleting restaurant: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error deleting restaurant: $error=========');
    }
  }
}
