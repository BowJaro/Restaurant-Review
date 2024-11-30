import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import '../controller/sign_in_controller.dart';
import '../provider/sign_in_provider.dart';
import '../repository/sign_in_repository.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInProvider>(() => SignInProvider(supabase));
    Get.lazyPut<SignInRepository>(
        () => SignInRepository(Get.find<SignInProvider>()));
    Get.lazyPut<SignInController>(
        () => SignInController(Get.find<SignInRepository>()));
  }
}
