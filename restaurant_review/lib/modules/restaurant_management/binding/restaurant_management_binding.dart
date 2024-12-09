import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/restaurant_management_controller.dart';
import '../provider/restaurant_management_provider.dart';
import '../repository/restaurant_management_repository.dart';

class RestaurantManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantManagementProvider>(
        () => RestaurantManagementProvider(supabase));
    Get.lazyPut<RestaurantManagementRepository>(() =>
        RestaurantManagementRepository(
            Get.find<RestaurantManagementProvider>()));
    Get.lazyPut<RestaurantManagementController>(() =>
        RestaurantManagementController(
            Get.find<RestaurantManagementRepository>()));
  }
}
