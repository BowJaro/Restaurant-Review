import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/my_post/model/my_post_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/my_post_repository.dart';

class MyPostController extends GetxController {
  final MyPostRepository repository;
  MyPostController(this.repository);

  RxBool isLoading = true.obs;
  RxList<MyPostModel> myPostList = <MyPostModel>[].obs;

  @override
  onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
      return;
    }
    await getData();
  }

  Future<void> getData() async {
    var response = await repository.getUserPosts(userId!);
    if (response != null) {
      myPostList.value = (response as List<dynamic>)
          .map((item) => MyPostModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle the error or null response
    }

    isLoading.value = false;
  }

  void removePost(int id) async {
    ModalUtils.showMessageWithButtonsModal(
      FlutterI18n.translate(Get.context!, "my_post.remove_post"),
      FlutterI18n.translate(Get.context!, "my_post.confirm_remove_post"),
      () async {
        myPostList.removeWhere((element) => element.postId == id);
        await repository.removePost(id);
      },
    );
  }
}
