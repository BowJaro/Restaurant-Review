import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/restaurant_page_controller.dart';
import '../provider/restaurant_page_provider.dart';
import '../repository/restaurant_page_repository.dart';

class RestaurantPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantPageProvider>(() => RestaurantPageProvider(supabase));
    Get.lazyPut<RestaurantPageRepository>(
        () => RestaurantPageRepository(Get.find<RestaurantPageProvider>()));
    Get.lazyPut<RestaurantPageController>(
        () => RestaurantPageController(Get.find<RestaurantPageRepository>()));
  }
}
