import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/my_post/model/my_post_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/my_post_repository.dart';

class MyPostController extends GetxController {
  final MyPostRepository repository;
  MyPostController(this.repository);

  RxBool isLoading = true.obs;
  List<MyPostModel> myPostList = [];

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
      myPostList = (response as List<dynamic>)
          .map((item) => MyPostModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle the error or null response
    }

    isLoading.value = false;
  }
}
