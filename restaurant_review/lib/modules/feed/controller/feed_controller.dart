import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/feed/model/post_detail_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../repository/feed_repository.dart';

class FeedController extends GetxController {
  final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
  final FeedRepository repository;
  var isLoadingAccountPage = false.obs;

  final List<PostDetail> followingPostList = [];
  final List<PostDetail> globalPostList = [];
  FeedController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }
    await fetchFollowingPostList();
    await fetchNewestPostList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchFollowingPostList() async {
    isLoadingAccountPage.value = true;
    final response = await repository.getListFollowingPost(userId!, 5);

    print('this is response1: ${response}');

    if (response != null) {
      followingPostList.addAll((response as List<dynamic>)
          .map((item) => PostDetail.fromMap(item as Map<String, dynamic>))
          .toList());
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
    isLoadingAccountPage.value = false;
  }

  Future<void> fetchNewestPostList() async {
    isLoadingAccountPage.value = true;
    final response = await repository.getNewestPost(1, userId!);
    if (response != null) {
      globalPostList.addAll((response as List<dynamic>)
          .map((item) => PostDetail.fromMap(item as Map<String, dynamic>))
          .toList());
      print('globalPostList $globalPostList');
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
    isLoadingAccountPage.value = false;
  }
}
