import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpProvider {
  final SupabaseClient _supabase;

  SignUpProvider(this._supabase);

  Future<dynamic> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
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

  Future<String?> getSessionId() async {
    try {
      final session = _supabase.auth.currentSession;

      if (session != null) {
        return session.user.id;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
