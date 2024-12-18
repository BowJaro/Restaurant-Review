import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;
final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
String? userId;

String? _permission; // don't use this variable, use below function instead

// Function to fetch and return the permission
Future<String> getPermission({bool fetchNew = false}) async {
  if (fetchNew) {
    _permission = null;
    try {
      if (userId == null) {
        Get.offAllNamed(Routes.splash);
      }

      final response = await supabase
          .from('profiles')
          .select('permission')
          .eq('id', userId!)
          .single();

      _permission = response['permission'];
    } catch (error) {
      print('Error fetching permission: $error');
      _permission = 'user'; // Default fallback
    }
  } else {
    if (_permission == null) {
      try {
        if (userId == null) {
          Get.offAllNamed(Routes.splash);
        }

        final response = await supabase
            .from('profiles')
            .select('permission')
            .eq('id', userId!)
            .single();

        _permission = response['permission'];
      } catch (error) {
        print('Error fetching permission: $error');
        _permission = 'user'; // Default fallback
      }
    }
  }

  return _permission!;
}
