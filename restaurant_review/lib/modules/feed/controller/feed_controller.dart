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

  var followingPostList = <PostDetail>[].obs;
  var globalPostList = <PostDetail>[].obs;
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
    final response = await repository.getNewestPost(5, userId!);
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

  void updateSavedPostInDatabase(int postId, bool isSaved) {
    if (isSaved == true) {
      repository.insertFollowingPost(userId!, postId.toString());
    } else if (isSaved == false) {
      repository.deleteFollowingPost(userId!, postId.toString());
    }
  }

  void updateReactionPostInDatabase(int postId, bool isLike, bool isDislike) {
    if (isLike == true && isDislike == false) {
      repository.upsertReaction(userId!, 'like', postId);
      print('like post inserted');
    } else if (isLike == false && isDislike == true) {
      repository.upsertReaction(userId!, 'dislike', postId);
      print('dislike post inserted');
    } else if (isLike == false && isDislike == false) {
      repository.deleteReaction(userId!, postId);
      print('delete post inserted');
    }
  }
}
