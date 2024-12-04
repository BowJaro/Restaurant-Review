import 'package:get/get.dart';
import 'package:restaurant_review/services/supabase.dart';

import '../controller/explore_controller.dart';
import '../provider/explore_provider.dart';
import '../repository/explore_repository.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreProvider>(() => ExploreProvider(supabase));
    Get.lazyPut<ExploreRepository>(
        () => ExploreRepository(Get.find<ExploreProvider>()));
    Get.lazyPut<ExploreController>(
        () => ExploreController(Get.find<ExploreRepository>()));
  }
}
