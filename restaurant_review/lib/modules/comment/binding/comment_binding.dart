import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/comment_controller.dart';
import '../provider/comment_provider.dart';
import '../repository/comment_repository.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentProvider>(() => CommentProvider(supabase));
    Get.lazyPut<CommentRepository>(
        () => CommentRepository(Get.find<CommentProvider>()));
    Get.lazyPut<CommentController>(
        () => CommentController(Get.find<CommentRepository>()));
  }
}
