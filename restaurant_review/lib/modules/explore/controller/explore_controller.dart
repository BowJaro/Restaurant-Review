import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/explore/model/mini_user_model.dart';
import 'package:restaurant_review/modules/explore/model/nearby_restaurant_model.dart';
import 'package:restaurant_review/modules/explore/model/popular_restaurant_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../repository/explore_repository.dart';

class ExploreController extends GetxController {
  final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
  final ExploreRepository repository;
  var isLoadingAccountPage = false.obs;

  var popularRestaurantList = <PopularRestaurantModel>[].obs;
  var topReviewerList = <MiniUserModel>[].obs;
  var topRatingRestaurantList = <PopularRestaurantModel>[].obs;
  var topNearbyRestaurantList = <NearbyRestaurantModel>[].obs;

  ExploreController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }

    await fetchTopReviewersList();
    await fetchPopularRestaurantsList();
    await fetchTopRatingRestaurantsList();
    await fetchTopNearbyRestaurantsList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchTopReviewersList() async {
    isLoadingAccountPage.value = true;
    final response = await repository.getTopReviewers(5);

    if (response != null) {
      topReviewerList.addAll((response as List<dynamic>)
          .map((item) => MiniUserModel.fromMap(item as Map<String, dynamic>))
          .toList());
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
    isLoadingAccountPage.value = false;
  }

  Future<void> fetchPopularRestaurantsList() async {
    isLoadingAccountPage.value = true;
    final response = await repository.getPopularRestaurants(5);

    if (response != null) {
      popularRestaurantList.addAll((response as List<dynamic>)
          .map((item) =>
              PopularRestaurantModel.fromMap(item as Map<String, dynamic>))
          .toList());
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
    isLoadingAccountPage.value = false;
  }

  Future<void> fetchTopRatingRestaurantsList() async {
    isLoadingAccountPage.value = true;
    final response = await repository.getTopRatingRestaurants(10);

    if (response != null) {
      topRatingRestaurantList.addAll((response as List<dynamic>)
          .map((item) =>
              PopularRestaurantModel.fromMap(item as Map<String, dynamic>))
          .toList());
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
    isLoadingAccountPage.value = false;
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return null; // Permission denied forever
      }
    }

    // Use settings parameter for platform-specific settings
    LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy
      distanceFilter: 10, // Update every 10 meters
    );

    return await Geolocator.getCurrentPosition(locationSettings: settings);
  }

  Future<void> fetchTopNearbyRestaurantsList() async {
    bool permissionGranted = await requestLocationPermission();
    if (!permissionGranted) {
      print("Location permission denied.");
      return;
    }

    Position? position = await getCurrentLocation();
    if (position != null) {
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      //isLoadingAccountPage.value = true;
      final response = await repository.getNearbyRestaurants(
          position.latitude, position.longitude, 20, 1000);

      if (response != null) {
        topNearbyRestaurantList.addAll((response as List<dynamic>)
            .map((item) =>
                NearbyRestaurantModel.fromMap(item as Map<String, dynamic>))
            .toList());
      } else {
        Get.back();
        ModalUtils.showMessageModal(
            FlutterI18n.translate(Get.context!, "error.unknown"));
      }
      //isLoadingAccountPage.value = false;
    } else {
      print("Could not get the location.");
    }
  }
}
