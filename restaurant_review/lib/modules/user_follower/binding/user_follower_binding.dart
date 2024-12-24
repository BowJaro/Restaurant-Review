import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/user_follower_controller.dart';
import '../provider/user_follower_provider.dart';
import '../repository/user_follower_repository.dart';

class UserFollowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserFollowerProvider>(() => UserFollowerProvider(supabase));
    Get.lazyPut<UserFollowerRepository>(
        () => UserFollowerRepository(Get.find<UserFollowerProvider>()));
    Get.lazyPut<UserFollowerController>(
        () => UserFollowerController(Get.find<UserFollowerRepository>()));
  }
}
