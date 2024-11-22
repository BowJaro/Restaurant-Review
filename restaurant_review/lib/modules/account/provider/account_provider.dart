import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();

  AccountProvider(this.supabase);

  Future<dynamic> fetchAccount(String id) async {
    try {
      final response =
          await supabase.rpc("get_profile_details", params: {"user_id": id});
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching account: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching account: $error=========');
      return null;
    }
  }
}
