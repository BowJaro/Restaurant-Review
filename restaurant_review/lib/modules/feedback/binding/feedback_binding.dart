import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/feedback_controller.dart';
import '../provider/feedback_provider.dart';
import '../repository/feedback_repository.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedbackProvider>(() => FeedbackProvider(supabase));
    Get.lazyPut<FeedbackRepository>(
        () => FeedbackRepository(Get.find<FeedbackProvider>()));
    Get.lazyPut<FeedbackController>(
        () => FeedbackController(Get.find<FeedbackRepository>()));
  }
}
