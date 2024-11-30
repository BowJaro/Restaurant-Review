import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/reactions.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/constants/strings.dart';
import 'package:restaurant_review/global_classes/mini_reaction.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/comment/model/comment_model.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../repository/comment_repository.dart';

class CommentController extends GetxController {
  late final int? postId;

  final CommentRepository repository;
  CommentController(this.repository);
  var commentList = <CommentModel>[].obs;
  final Map<int, Timer?> _reactionTimers = {};

  final inputController = TextEditingController();
  final inputFocusNode = FocusNode();
  var isReplying = false.obs;
  var replyToName = ''.obs;
  var replyToId = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    final arguments = Get.arguments;
    postId = arguments?['post_id'];

    if (userId == null || postId == null) {
      Get.offAllNamed(Routes.signIn);
      return;
    }
    await getData();
  }

  @override
  void onClose() {
    inputController.dispose(); // Dispose controller
    inputFocusNode.dispose(); // Dispose focus node
    super.onClose();
  }

  Future<void> getData() async {
    var response = await repository.getComments(postId!, userId!);
    commentList.value = (response as List<dynamic>)
        .map((item) => CommentModel.fromMap(item))
        .toList();
  }

  Icon getIcon(String reactionType) {
    return Icon(
      getReactionIcon(reactionType),
      size: 16,
    );
  }

  Icon getHeartIcon(MiniReactionModel? reaction) {
    if (reaction == null ||
        reaction.content.value == IconStrings.defaultString) {
      return Icon(
        getReactionIcon(IconStrings.defaultString),
        size: 16,
      );
    } else if (reaction.content.value == IconStrings.like) {
      return Icon(
        getReactionIcon(IconStrings.like),
        size: 16,
        color: AppColors.blue,
      );
    } else {
      return Icon(
        getReactionIcon(IconStrings.dislike),
        size: 16,
        color: AppColors.primary,
      );
    }
  }

  List<Widget> getIconRow(BaseCommentModel comment) {
    List<Widget> reactionIcons = [];
    if (comment.reactionCounts == null) {
      return reactionIcons;
    }
    for (var reaction in comment.reactionCounts!) {
      if (reaction.name == IconStrings.defaultString) continue;
      reactionIcons.add(getIcon(reaction.name));
      reactionIcons.add(const SizedBox(width: 5));
    }
    return reactionIcons;
  }

  /// Focus the input field and set reply context
  void focusReplyField(BaseCommentModel comment) {
    isReplying.value = true;
    replyToName.value = comment.fullName ??
        FlutterI18n.translate(Get.context!, "comment.unknown");
    replyToId.value = comment.id;
    inputFocusNode.requestFocus();
  }

  void resetReplyMode() {
    isReplying.value = false;
    replyToName.value = '';
    replyToId.value = 0;
    inputFocusNode.unfocus();
  }

  /// Handle "Send" button press
  void handleSend() async {
    final inputText = inputController.text.trim();

    if (inputText.isNotEmpty) {
      try {
        final isReply = isReplying.value;
        final targetType = isReply ? "comment" : "post";
        final targetSource = isReply ? replyToId.value : postId!;

        // Clear the input field and reset reply state
        inputController.clear();
        inputFocusNode.unfocus();
        isReplying.value = false;

        // Call repository to insert the comment
        await repository.insertComment(
          content: inputText,
          source: targetSource,
          type: targetType,
          profileId: userId!,
        );

        // Refresh the comment list
        await getData();
      } catch (e) {
        print("Failed to send comment: $e");
      }
    }
  }

  /// Debounce reaction calls to minimize server hits
  void debounceReaction(BaseCommentModel comment, String reaction) {
    _reactionTimers[comment.id]?.cancel(); // Cancel existing timer
    _reactionTimers[comment.id] = Timer(const Duration(milliseconds: 800), () {
      upsertReaction(comment, reaction);
      _reactionTimers.remove(comment.id); // Remove timer after execution
    });
  }

  void upsertReaction(BaseCommentModel comment, String reaction) async {
    final reactionId = comment.myReaction?.value.id;
    final response = await repository.upsertReaction(
      reactionId: reactionId == 0 ? null : reactionId,
      source: comment.id,
      content: reaction,
      profileId: userId!,
    );
    if (comment.myReaction == null) {
      comment.myReaction!.value =
          MiniReactionModel(id: response as int, content: reaction.obs);
    } else {
      comment.myReaction!.value.content.value = reaction;
    }
  }

  /// Handles the toggle logic for heart button
  void toggleReaction(BaseCommentModel comment, String reaction) {
    final currentReaction = comment.myReaction?.value.content.value;
    final newReaction =
        (currentReaction == reaction) ? IconStrings.defaultString : reaction;

    // Update the reaction locally
    comment.myReaction = newReaction.isNotEmpty
        ? MiniReactionModel(
                id: comment.myReaction?.value.id ?? 0, content: newReaction.obs)
            .obs
        : null;

    commentList.refresh(); // Refresh UI
    debounceReaction(comment, newReaction); // Debounce the server update
  }

  void removeComment(int commentId) async {
    // Call API to remove the comment
    ModalUtils.showMessageWithButtonsModal(
      FlutterI18n.translate(Get.context!, "comment.remove_comment"),
      FlutterI18n.translate(Get.context!, "comment.confirm_remove"),
      () async {
        Get.back();
        await repository.removeComment(commentId);
        getData();
      },
    );
  }

  void reportComment(int commentId) {
    // Navigate to the reporting module (future implementation)
    print("Reporting comment with ID: $commentId");
    // TODO: Pass data to the report module
  }
}
