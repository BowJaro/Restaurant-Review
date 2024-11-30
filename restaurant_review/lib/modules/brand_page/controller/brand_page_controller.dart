import 'dart:async';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/restaurant_card_model.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../model/brand_page_model.dart';
import '../repository/brand_page_repository.dart';

class BrandPageController extends GetxController {
  final BrandPageRepository repository;
  BrandPageController(this.repository);

  late final int brandId;
  late BrandPageModel brandPageModel;
  RxBool isLoading = true.obs;

  Timer? _debounceTimer;
  final Map<int, int> clickCounts = {};

  @override
  void onInit() async {
    super.onInit();
    brandId = Get.arguments['brandId'];

    if (userId == null) {
      Get.offAllNamed(Routes.signIn);
    } else {
      await getData();
    }
  }

  Future<void> getData() async {
    final response = await repository.getBrandPage(brandId, userId!);
    if (response != null) {
      brandPageModel = BrandPageModel.fromMap(response as Map<String, dynamic>);
    } else {
      // Handle the error or null response
    }

    isLoading.value = false;
  }

  void onHeartTap(RestaurantCardModel restaurant) {
    // Increment click count for the restaurant
    clickCounts[restaurant.id] = (clickCounts[restaurant.id] ?? 0) + 1;

    // Update the UI immediately
    restaurant.isFollowed.value = !restaurant.isFollowed.value;

    // Cancel any previous debounce timer
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    // Start a new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // Only call API if the click count is odd
      if ((clickCounts[restaurant.id] ?? 0) % 2 != 0) {
        try {
          await repository.toggleFollowing(
            source: restaurant.id,
            type: "restaurant",
            profileId: userId!,
          );
        } catch (e) {
          // Revert the UI if the API call fails
          restaurant.isFollowed.value = !restaurant.isFollowed.value;
          ModalUtils.showMessageModal(
              FlutterI18n.translate(Get.context!, "error.unknown"));
        }
      }

      // Reset the click count for the restaurant
      clickCounts[restaurant.id] = 0;
    });
  }
}
