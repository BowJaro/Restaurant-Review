import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/user_follower/model/user_follower_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../repository/user_follower_repository.dart';

class UserFollowerController extends GetxController {
  final UserFollowerRepository repository;
  UserFollowerController(this.repository);

  RxList<UserFollowerModel>? userFollowerList = <UserFollowerModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
      return;
    }
    await getFollowers();
    isLoading.value = false;
  }

  Future<void> getFollowers() async {
    final response = await repository.getFollowers(userId!);
    if (response != null) {
      if (userFollowerList == null) {
        userFollowerList = (response as List<dynamic>)
            .map((item) =>
                UserFollowerModel.fromMap(item as Map<String, dynamic>))
            .toList()
            .obs;
      } else {
        userFollowerList!.value = (response as List<dynamic>)
            .map((item) =>
                UserFollowerModel.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } else {
      // Handle the error or null response
    }
  }

  void removeFollowers(String profileId, String type) async {
    await repository.removeFollowers(
        profileId: profileId, source: userId!, type: type);
    await getFollowers();
  }

  void goToUserPage(String profileId) async {
    await Get.toNamed(Routes.user, arguments: {'userId': profileId});
    getFollowers();
  }
}
