import 'dart:async';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/map_restaurant.dart';
import 'package:restaurant_review/global_classes/mini_post_card.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/global_widgets/restaurants_map/restaurants_map.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../model/get_restaurant_post_model.dart';
import '../repository/restaurant_page_repository.dart';

class RestaurantPageController extends GetxController {
  final RestaurantPageRepository repository;
  RestaurantPageController(this.repository);

  RxBool isLoading = true.obs;
  final int? restaurantId = Get.arguments['id'];

  List<Rx<PostModel>> postList = <Rx<PostModel>>[].obs;
  late RestaurantModel restaurantModel;

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }
    if (restaurantId == null) {
      Get.back();
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "restaurant_page.unknown_restaurant"));
    }
    await getData(restaurantId!);
    isLoading.value = false;
  }

  Future<void> getData(int restaurantId) async {
    var response = await repository.getRestaurantAndPosts(
        restaurantId: restaurantId, profileId: userId!);
    if (response != null) {
      RestaurantAndPostsModel getRestaurantPostModel =
          RestaurantAndPostsModel.fromMap(response as Map<String, dynamic>);
      restaurantModel = getRestaurantPostModel.restaurant;
      postList.assignAll(
          getRestaurantPostModel.postList.map((e) => Rx<PostModel>(e)));
    }
  }

  int clickCounts = 0;
  Timer? _debounceTimer;

  void toggleFollowing() {
    clickCounts++;
    restaurantModel.isFollowed.value = !restaurantModel.isFollowed.value;

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (clickCounts % 2 != 0) {
        await repository.toggleFollowing(
            source: restaurantId.toString(),
            type: "restaurant",
            profileId: userId!);
      }

      clickCounts = 0;
    });
  }

  void goToGoogleMap() async {
    Get.to(() => RestaurantsMap(
          restaurants: [
            MapRestaurantModel(
              id: restaurantId!,
              imageUrl: restaurantModel.imageUrl,
              name: restaurantModel.name,
              rateAverage: restaurantModel.averageRate,
              latitude: restaurantModel.latitude,
              longitude: restaurantModel.longitude,
            )
          ],
        ));
  }
}
