import 'package:supabase_flutter/supabase_flutter.dart';

class SignInProvider {
  final SupabaseClient _supabase;

  SignInProvider(this._supabase);

  Future<dynamic> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } on AuthException catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }
}
