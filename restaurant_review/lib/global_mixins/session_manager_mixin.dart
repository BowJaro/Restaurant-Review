import 'package:shared_preferences/shared_preferences.dart';

mixin SessionManagerMixin {
  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }
}
