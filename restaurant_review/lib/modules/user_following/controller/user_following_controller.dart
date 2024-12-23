import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/following/model/following_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/user_following_repository.dart';

class UserFollowingController extends GetxController {
  final UserFollowingRepository repository;
  UserFollowingController(this.repository);
  Rx<FollowingModel>? followingModel;

  RxBool isLoading = true.obs;

  @override
  onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
      return;
    }
    await getFollowing();
    isLoading.value = false;
  }

  Future<void> getFollowing() async {
    final response = await repository.getFollowing(userId!);
    if (response != null) {
      if (followingModel == null) {
        followingModel =
            FollowingModel.fromMap(response as Map<String, dynamic>).obs;
      } else {
        followingModel!.value =
            FollowingModel.fromMap(response as Map<String, dynamic>);
      }
    } else {
      // Handle the error or null response
    }
  }

  void removeFollowing(String source, String type) async {
    await repository.removeFollowing(
        profileId: userId!, source: source, type: type);
    await getFollowing();
  }

  void goToUserPage(String profileId) async {
    await Get.toNamed(Routes.user, arguments: {'userId': profileId});
    getFollowing();
  }
}
