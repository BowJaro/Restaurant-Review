// splash_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Get.offNamed(Routes.home);
    } else {
      Get.offNamed(Routes.signIn);
    }
  }
}
