import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/user_following_controller.dart';
import '../provider/user_following_provider.dart';
import '../repository/user_following_repository.dart';

class UserFollowingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserFollowingProvider>(() => UserFollowingProvider(supabase));
    Get.lazyPut<UserFollowingRepository>(
        () => UserFollowingRepository(Get.find<UserFollowingProvider>()));
    Get.lazyPut<UserFollowingController>(
        () => UserFollowingController(Get.find<UserFollowingRepository>()));
  }
}
