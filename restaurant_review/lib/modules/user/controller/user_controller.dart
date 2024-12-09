import 'dart:async';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../model/get_user_post_model.dart';
import '../repository/user_repository.dart';

class UserController extends GetxController {
  final UserRepository repository;
  UserController(this.repository);

  final String? targetProfileId = Get.arguments['userId'];
  RxBool isLoading = true.obs;
  List<Rx<PostModel>> postList = <Rx<PostModel>>[].obs;
  late UserModel userModel;

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }
    if (targetProfileId == null) {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "user.unknown_user"));
    }
    await getData();
    isLoading.value = false;
  }

  Future<void> getData() async {
    var response = await repository.getUserAndPosts(
        targetProfileId: targetProfileId!, myProfileId: userId!);

    if (response != null) {
      UserAndPostsModel userAndPostsModel =
          UserAndPostsModel.fromMap(response as Map<String, dynamic>);
      userModel = userAndPostsModel.user;
      postList
          .assignAll(userAndPostsModel.postList.map((e) => Rx<PostModel>(e)));
    }
  }

  int clickCounts = 0;
  Timer? _debounceTimer;

  void toggleFollowing() {
    clickCounts++;
    userModel.isFollowed.value = !userModel.isFollowed.value;

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (clickCounts % 2 != 0) {
        await repository.toggleFollowing(
            source: targetProfileId!, type: "user", profileId: userId!);
      }

      clickCounts = 0;
    });
  }
}
