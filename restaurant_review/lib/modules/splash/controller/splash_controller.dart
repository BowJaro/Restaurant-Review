// splash_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 1));
    final session = supabase.auth.currentSession;
    userId = session?.user.id;

    if (session != null) {
      Get.offNamed(Routes.home);
    } else {
      Get.offNamed(Routes.signIn);
    }
  }
}
