import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/user_controller.dart';
import '../provider/user_provider.dart';
import '../repository/user_repository.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(() => UserProvider(supabase));
    Get.lazyPut<UserRepository>(() => UserRepository(Get.find<UserProvider>()));
    Get.lazyPut<UserController>(
        () => UserController(Get.find<UserRepository>()));
  }
}
