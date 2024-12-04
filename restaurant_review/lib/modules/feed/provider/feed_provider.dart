import 'package:supabase_flutter/supabase_flutter.dart';

class FeedProvider {
  final SupabaseClient supabase;

  FeedProvider(this.supabase);

  Future<dynamic> fetchPostDetail(int id) async {
    try {
      final response =
          await supabase.rpc("get_post_detail", params: {"post_id": id});
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching post: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching post: $error=========');
      return null;
    }
  }
}
