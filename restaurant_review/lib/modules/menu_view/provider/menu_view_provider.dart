import 'package:supabase_flutter/supabase_flutter.dart';

class MenuViewProvider {
  final SupabaseClient supabase;

  MenuViewProvider(this.supabase);

  /// Call the stored procedure to get menu items
  Future<dynamic> getMenuItems(int restaurantId) async {
    try {
      return await supabase.rpc('get_menu_items', params: {
        'p_restaurant_id': restaurantId,
      });
    } on PostgrestException catch (error) {
      print('=========Error fetching menu items: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching menu items: $error=========');
      return null;
    }
  }
}
