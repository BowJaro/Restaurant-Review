import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/following/model/following_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/following_repository.dart';

class FollowingController extends GetxController {
  final FollowingRepository repository;
  FollowingController(this.repository);
  late Rx<FollowingModel> followingModel;

  RxBool isLoading = true.obs;

  @override
  onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
      return;
    }
    await getFollowing();
  }

  Future<void> getFollowing() async {
    final response = await repository.getFollowing(userId!);
    if (response != null) {
      followingModel =
          FollowingModel.fromMap(response as Map<String, dynamic>).obs;
    } else {
      // Handle the error or null response
    }

    isLoading.value = false;
  }

  void removeFollowing(String source, String type) async {
    await repository.removeFollowing(
        profileId: userId!, source: source, type: type);
    await getFollowing();
  }
}
