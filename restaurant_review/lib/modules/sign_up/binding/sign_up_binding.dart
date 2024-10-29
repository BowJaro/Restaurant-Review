import 'package:get/get.dart';
import 'package:restaurant_review/modules/sign_up/provider/sign_up_provider.dart';
import 'package:restaurant_review/modules/sign_up/repository/sign_up_repository.dart';
import 'package:restaurant_review/services/supabase.dart';
import '../controller/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpProvider>(() => SignUpProvider(supabase));
    Get.lazyPut<SignUpRepository>(
        () => SignUpRepository(Get.find<SignUpProvider>()));
    Get.lazyPut<SignUpController>(
        () => SignUpController(Get.find<SignUpRepository>()));
  }
}
