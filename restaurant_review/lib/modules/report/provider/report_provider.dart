import 'package:supabase_flutter/supabase_flutter.dart';

class ReportProvider {
  final SupabaseClient supabase;

  ReportProvider(this.supabase);

  /// Call the stored procedure to insert report
  Future<void> insertReport(
      {required String source,
      required String type,
      required String title,
      required String description}) async {
    try {
      await supabase.rpc('insert_report', params: {
        'p_source': source,
        'p_type': type,
        'p_title': title,
        'p_description': description,
      });
    } on PostgrestException catch (error) {
      print('=========Error inserting report: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error inserting report: $error=========');
    }
  }
}
