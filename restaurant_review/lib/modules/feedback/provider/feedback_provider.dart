import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackProvider {
  final SupabaseClient supabase;

  FeedbackProvider(this.supabase);

  /// Call the stored procedure to insert feedback
  Future<void> insertFeedback(String title, String description) async {
    try {
      await supabase.rpc('insert_feedback', params: {
        'p_title': title,
        'p_description': description,
      });
    } on PostgrestException catch (error) {
      print('=========Error inserting feedback: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error inserting feedback: $error=========');
    }
  }
}
