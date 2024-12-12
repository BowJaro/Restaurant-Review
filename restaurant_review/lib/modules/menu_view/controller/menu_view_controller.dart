import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/menu_view/model/menu_view_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/menu_view_repository.dart';

class MenuViewController extends GetxController {
  final MenuViewRepository repository;
  MenuViewController(this.repository);

  final int? restaurantId = Get.arguments['restaurantId'];
  RxBool isLoading = true.obs;
  List<MenuItem> menuItemList = [];

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }
    if (restaurantId == null) {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "menu_view.not_exist"));
      return;
    }
    await getData();
    isLoading.value = false;
  }

  Future<void> getData() async {
    final response = await repository.getMenuItems(restaurantId!);
    if (response != null) {
      menuItemList = (response as List<dynamic>)
          .map((item) => MenuItem.fromMap(item as Map<String, dynamic>))
          .toList();
    }
  }
}
