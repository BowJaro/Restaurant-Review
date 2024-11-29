import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';

import '../controller/comment_controller.dart';
import '../widget/comment_tree.dart';

class CommentView extends GetView<CommentController> {
  const CommentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "comment.comments")),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Main content: Comment List
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 55,
              ),
              child: Obx(() {
                return CommentTree(
                  comments: controller.commentList.value,
                  onHeartEvent: (comment, reaction) {
                    controller.toggleReaction(comment, reaction);
                  },
                  onReplyTap: (comment) {
                    controller.focusReplyField(comment);
                  },
                  controller: controller,
                );
              }),
            ),
          ),
          // Input Field at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() {
              return Container(
                color: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  children: [
                    // TextField for input
                    Expanded(
                      child: TextField(
                        controller: controller.inputController,
                        focusNode: controller.inputFocusNode,
                        decoration: InputDecoration(
                          hintText: controller.isReplying.value
                              ? "${FlutterI18n.translate(context, "comment.reply_to")} ${controller.replyToName.value}"
                              : FlutterI18n.translate(
                                  context, "comment.write_comment"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Remove icon when in reply mode
                    if (controller.isReplying.value)
                      IconButton(
                        icon:
                            const Icon(Icons.close, color: AppColors.textGray),
                        onPressed: () {
                          controller.resetReplyMode();
                          controller.inputController.clear();
                        },
                      ),
                    // Send Button
                    IconButton(
                      onPressed: () {
                        controller.handleSend();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
