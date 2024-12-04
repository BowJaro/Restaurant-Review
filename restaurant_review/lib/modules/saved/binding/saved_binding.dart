import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/saved_controller.dart';
import '../provider/saved_provider.dart';
import '../repository/saved_repository.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedProvider>(() => SavedProvider(supabase));
    Get.lazyPut<SavedRepository>(
        () => SavedRepository(Get.find<SavedProvider>()));
    Get.lazyPut<SavedController>(
        () => SavedController(Get.find<SavedRepository>()));
  }
}
