import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/following_controller.dart';
import '../provider/following_provider.dart';
import '../repository/following_repository.dart';

class FollowingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowingProvider>(() => FollowingProvider(supabase));
    Get.lazyPut<FollowingRepository>(
        () => FollowingRepository(Get.find<FollowingProvider>()));
    Get.lazyPut<FollowingController>(
        () => FollowingController(Get.find<FollowingRepository>()));
  }
}
