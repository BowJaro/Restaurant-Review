import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;
final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
String? userId;
