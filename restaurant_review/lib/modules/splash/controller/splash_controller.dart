// splash_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/services/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    final session = supabase.auth.currentSession;

    final prefs = await SharedPreferences.getInstance();

    if (session != null) {
      await prefs.setString('sessionId', session.user.id);
      Get.offNamed(Routes.home);
    } else {
      await prefs.remove('sessionId');
      Get.offNamed(Routes.signIn);
    }
  }
}
