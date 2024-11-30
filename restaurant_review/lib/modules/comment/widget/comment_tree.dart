import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/constants/strings.dart';
import 'package:restaurant_review/modules/comment/controller/comment_controller.dart';

import '../model/comment_model.dart';
import 'comment_row.dart';

class CommentTree extends StatelessWidget {
  final List<CommentModel> comments;
  final void Function(BaseCommentModel comment, String reaction) onHeartEvent;
  final void Function(BaseCommentModel comment) onReplyTap;
  final CommentController controller;
  const CommentTree({
    super.key,
    required this.comments,
    required this.onHeartEvent,
    required this.onReplyTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments.map((comment) {
        final reactionCount = comment.reactionCounts?.fold<int>(
            0,
            (previousValue, element) =>
                element.name != IconStrings.defaultString
                    ? previousValue + element.number
                    : previousValue);
        final dateArray = comment.createdAt.toLocal().toString().split(' ');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main comment row
            CommentRow(
              avatarUrl: comment.avatarUrl ?? '',
              fullName: comment.fullName ??
                  FlutterI18n.translate(context, "comment.unknown"),
              content: comment.content,
              icon: controller.getHeartIcon(comment.myReaction?.value),
              date: "${dateArray[0]} ${dateArray[1].substring(0, 8)}",
              reactionsCount: reactionCount ?? 0,
              onHeartTap: () => onHeartEvent(comment, IconStrings.like),
              onHeartDoubleTap: () =>
                  onHeartEvent(comment, IconStrings.dislike),
              onReplyTap: () => onReplyTap(comment),
              reactionIcons: controller.getIconRow(comment),
              menuOptions: () {
                final options = <PopupMenuEntry<String>>[];
                if (userId == comment.profileId) {
                  options.add(
                    PopupMenuItem(
                      value: "remove",
                      child: Text(
                          FlutterI18n.translate(context, "comment.remove")),
                      onTap: () => controller.removeComment(comment.id),
                    ),
                  );
                } else {
                  options.add(
                    PopupMenuItem(
                      value: "report",
                      child: Text(
                          FlutterI18n.translate(context, "comment.report")),
                    ),
                  );
                }
                return options;
              },
            ),
            // Replies (if any)
            if (comment.replies != null)
              ...comment.replies!.map((reply) {
                final replyDateArray =
                    reply.createdAt.toLocal().toString().split(' ');
                final reactionReplyCount = reply.reactionCounts?.fold<int>(
                    0,
                    (previousValue, element) =>
                        element.name != IconStrings.defaultString
                            ? previousValue + element.number
                            : previousValue);
                return CommentRow(
                  avatarUrl: reply.avatarUrl ?? '',
                  fullName: reply.fullName ??
                      FlutterI18n.translate(context, "comment.unknown"),
                  content: reply.content,
                  icon: controller.getHeartIcon(reply.myReaction?.value),
                  date:
                      "${replyDateArray[0]} ${replyDateArray[1].substring(0, 8)}",
                  reactionsCount: reactionReplyCount ?? 0,
                  onHeartTap: () => onHeartEvent(reply, IconStrings.like),
                  onHeartDoubleTap: () =>
                      onHeartEvent(reply, IconStrings.dislike),
                  onReplyTap: () => onReplyTap(comment),
                  paddingLeft: 45.0,
                  reactionIcons: controller.getIconRow(reply),
                  menuOptions: () {
                    final options = <PopupMenuEntry<String>>[];
                    if (userId == reply.profileId) {
                      options.add(
                        PopupMenuItem(
                          value: "remove",
                          child: Text(
                              FlutterI18n.translate(context, "comment.remove")),
                          onTap: () => controller.removeComment(reply.id),
                        ),
                      );
                    } else {
                      options.add(
                        PopupMenuItem(
                          value: "report",
                          child: Text(
                              FlutterI18n.translate(context, "comment.report")),
                        ),
                      );
                    }
                    return options;
                  },
                );
              }),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }
}
