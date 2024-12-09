import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/full_brand.dart';
import 'package:restaurant_review/global_classes/restaurant_card_model.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/restaurant_management/model/get_restaurant_management_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/restaurant_management_repository.dart';

class RestaurantManagementController extends GetxController {
  final RestaurantManagementRepository repository;
  RestaurantManagementController(this.repository);

  RxBool isLoading = true.obs;
  List<Rx<RestaurantCardModel>> restaurantList =
      <Rx<RestaurantCardModel>>[].obs;
  BrandModel? brandModel;

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
      return;
    }
    await getData();
  }

  Future<void> getData() async {
    var response = await repository.getUserRestaurants(userId!);

    if (response != null) {
      GetRestaurantManagementModel getRestaurantManagementModel =
          GetRestaurantManagementModel.fromMap(
              response as Map<String, dynamic>);
      brandModel = getRestaurantManagementModel.brand;
      restaurantList.clear();
      restaurantList.addAll(
          getRestaurantManagementModel.restaurantList.map((e) => e.obs));
    }
    isLoading.value = false;
  }

  Future<void> removeRestaurant(int id) async {
    await repository.deleteRestaurant(id);
    getData();
  }

  void confirmRemoveRestaurant(int id) {
    ModalUtils.showMessageWithButtonsModal(
        FlutterI18n.translate(
            Get.context!, "restaurant_management.remove_restaurant"),
        FlutterI18n.translate(
            Get.context!, "restaurant_management.confirm_remove_restaurant"),
        () {
      Get.back();
      removeRestaurant(id);
    });
  }
}
