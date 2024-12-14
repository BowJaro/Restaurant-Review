import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/menu_creation_controller.dart';
import '../provider/menu_creation_provider.dart';
import '../repository/menu_creation_repository.dart';

class MenuCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuCreationProvider>(() => MenuCreationProvider(supabase));
    Get.lazyPut<MenuCreationRepository>(
        () => MenuCreationRepository(Get.find<MenuCreationProvider>()));
    Get.lazyPut<MenuCreationController>(
        () => MenuCreationController(Get.find<MenuCreationRepository>()));
  }
}
