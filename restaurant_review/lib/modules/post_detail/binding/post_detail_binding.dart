import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/post_detail/controller/post_detail_controller.dart';
import 'package:restaurant_review/modules/post_detail/provider/post_detail_provider.dart';
import 'package:restaurant_review/modules/post_detail/repository/post_detail_repository.dart';

class PostDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostDetailProvider>(() => PostDetailProvider(supabase));
    Get.lazyPut<PostDetailRepository>(
        () => PostDetailRepository(Get.find<PostDetailProvider>()));
    Get.lazyPut<PostDetailController>(
        () => PostDetailController(Get.find<PostDetailRepository>()));
  }
}
