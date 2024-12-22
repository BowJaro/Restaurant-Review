import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;
final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
String? userId;

// Function to fetch and return the permission
Future<String> getPermission() async {
  if (userId == null) {
    return "user";
  }
  final response = await supabase
      .from('profiles')
      .select('permission')
      .eq('id', userId!)
      .single();

  return response['permission'];
}
