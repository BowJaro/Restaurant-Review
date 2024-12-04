import 'package:get/get.dart';
import 'package:restaurant_review/services/supabase.dart';

import '../controller/feed_controller.dart';
import '../provider/feed_provider.dart';
import '../repository/feed_repository.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedProvider>(() => FeedProvider(supabase));
    Get.lazyPut<FeedRepository>(() => FeedRepository(Get.find<FeedProvider>()));
    Get.lazyPut<FeedController>(
        () => FeedController(Get.find<FeedRepository>()));
  }
}
