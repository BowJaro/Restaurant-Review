import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/my_post_controller.dart';
import '../provider/my_post_provider.dart';
import '../repository/my_post_repository.dart';

class MyPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPostProvider>(() => MyPostProvider(supabase));
    Get.lazyPut<MyPostRepository>(
        () => MyPostRepository(Get.find<MyPostProvider>()));
    Get.lazyPut<MyPostController>(
        () => MyPostController(Get.find<MyPostRepository>()));
  }
}
