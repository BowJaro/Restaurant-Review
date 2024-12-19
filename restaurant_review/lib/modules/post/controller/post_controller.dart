import 'dart:async';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/constants/strings.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/post/model/post_page_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/post_repository.dart';

class PostController extends GetxController {
  final PostRepository repository;
  PostController(this.repository);

  final int? postId = Get.arguments['postId'];
  RxBool isLoading = true.obs;
  late PostPageModel postModel;

  Timer? reactionTimer;
  Timer? saveTimer;

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }
    if (postId == null) {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "post.unknown_post"));
      return;
    }
    await getData();
    isLoading.value = false;
  }

  Future<void> getData() async {
    final response = await repository.getPostPage(postId!, userId!);
    if (response != null) {
      postModel = PostPageModel.fromMap(response as Map<String, dynamic>);
    } else {
      // Handle the error or null response
    }
  }

  void openReportPage(int postId) {
    Get.toNamed(Routes.report,
        arguments: {"type": "post", "source": postId.toString()});
  }

  void openCommentPage(int postId) {
    Get.toNamed(Routes.comment, arguments: {"post_id": postId});
  }

  String dateToString(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  void updateReaction(bool isLike) {
    if (isLike) {
      postModel.isLike.value = !postModel.isLike.value;
      postModel.isDislike.value = false;
    } else {
      postModel.isDislike.value = !postModel.isDislike.value;
      postModel.isLike.value = false;
    }

    reactionTimer?.cancel();
    // Cancel any existing timer
    reactionTimer = Timer(const Duration(milliseconds: 500), () {
      final String content = postModel.isLike.value
          ? IconStrings.like
          : postModel.isDislike.value
              ? IconStrings.dislike
              : IconStrings.defaultString;

      repository.upsertReaction(
        reactionId: null,
        source: postId!,
        content: content,
        profileId: userId!,
      );
    });
  }

  void savePost() {
    postModel.isSaved.value = !postModel.isSaved.value;
    saveTimer?.cancel();

    // Cancel any existing timer
    saveTimer = Timer(const Duration(milliseconds: 500), () {
      repository.toggleFollowing(
          profileId: userId!, source: postId.toString(), type: "post");
    });
  }
}
