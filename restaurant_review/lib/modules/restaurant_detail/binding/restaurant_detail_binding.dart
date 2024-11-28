import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import '../controller/restaurant_detail_controller.dart';
import '../provider/restaurant_detail_provider.dart';
import '../repository/restaurant_detail_repository.dart';

class RestaurantDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantDetailProvider>(
        () => RestaurantDetailProvider(supabase));
    Get.lazyPut<RestaurantDetailRepository>(
        () => RestaurantDetailRepository(Get.find<RestaurantDetailProvider>()));
    Get.lazyPut<RestaurantDetailController>(() =>
        RestaurantDetailController(Get.find<RestaurantDetailRepository>()));
  }
}
