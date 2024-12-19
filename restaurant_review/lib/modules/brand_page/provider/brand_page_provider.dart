import 'package:supabase_flutter/supabase_flutter.dart';

class BrandPageProvider {
  final SupabaseClient supabase;

  BrandPageProvider(this.supabase);

  /// Call the stored procedure to get brand page
  Future<dynamic> getBrandPage(int brandId, String profileId) async {
    try {
      return await supabase.rpc('get_brand_page', params: {
        'p_brand_id': brandId,
        'p_profile_id': profileId,
      });
    } on PostgrestException catch (error) {
      print('=========Error fetching brand page: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching brand page: $error=========');
      return null;
    }
  }

  /// Call the stored procedure to toggle following
  Future<void> toggleFollowing(
      int source, String type, String profileId) async {
    try {
      await supabase.rpc('toggle_following', params: {
        'p_profile_id': profileId,
        'p_source': source.toString(),
        'p_type': type,
      });
    } on PostgrestException catch (error) {
      print('=========Error toggling following: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error toggling following: $error=========');
    }
  }
}
