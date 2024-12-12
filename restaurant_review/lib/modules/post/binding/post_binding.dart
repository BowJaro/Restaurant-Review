import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/post_controller.dart';
import '../provider/post_provider.dart';
import '../repository/post_repository.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostProvider>(() => PostProvider(supabase));
    Get.lazyPut<PostRepository>(() => PostRepository(Get.find<PostProvider>()));
    Get.lazyPut<PostController>(
        () => PostController(Get.find<PostRepository>()));
  }
}
