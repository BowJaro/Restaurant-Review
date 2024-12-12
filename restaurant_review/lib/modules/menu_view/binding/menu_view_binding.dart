import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/menu_view_controller.dart';
import '../provider/menu_view_provider.dart';
import '../repository/menu_view_repository.dart';

class MenuViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuViewProvider>(() => MenuViewProvider(supabase));
    Get.lazyPut<MenuViewRepository>(
        () => MenuViewRepository(Get.find<MenuViewProvider>()));
    Get.lazyPut<MenuViewController>(
        () => MenuViewController(Get.find<MenuViewRepository>()));
  }
}
