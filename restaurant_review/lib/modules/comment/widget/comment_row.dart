import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

class CommentRow extends StatelessWidget {
  final String avatarUrl;
  final String fullName;
  final String content;
  final Icon icon;
  final String date;
  final int reactionsCount;
  final VoidCallback onHeartTap;
  final VoidCallback onHeartDoubleTap;
  final VoidCallback onReplyTap;
  final double paddingLeft;
  final List<Widget> reactionIcons;
  final List<PopupMenuEntry<String>> Function() menuOptions;

  const CommentRow({
    super.key,
    required this.avatarUrl,
    required this.fullName,
    required this.content,
    required this.icon,
    required this.date,
    required this.reactionsCount,
    required this.onHeartTap,
    required this.onHeartDoubleTap,
    required this.onReplyTap,
    this.paddingLeft = 0.0,
    required this.reactionIcons,
    required this.menuOptions,
  });

  @override
  Widget build(BuildContext context) {
    final String fullAvatarUrl = baseImageUrl + avatarUrl;

    return Padding(
      padding: EdgeInsets.only(left: paddingLeft, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatarUrl.isEmpty
              ? CircleAvatar(
                  radius: paddingLeft < 1 ? 20 : 17,
                  child: const Icon(Icons.person, size: 30),
                )
              : CircleAvatar(
                  radius: paddingLeft < 1 ? 20 : 17,
                  backgroundImage: NetworkImage(fullAvatarUrl),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPressStart: (details) async {
                    final value = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                        Get.size.width - details.globalPosition.dx,
                        Get.size.height - details.globalPosition.dy,
                      ),
                      items: menuOptions(),
                    );
                    if (value != null) {
                      menuOptions()
                          .whereType<PopupMenuItem<String>>()
                          .firstWhere((item) => item.value == value)
                          .onTap
                          ?.call();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGray,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full name
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // Comment content
                        const SizedBox(height: 4),
                        Text(content),
                      ],
                    ),
                  ),
                ),
                // Footer row
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                    Row(
                      children: [
                        // Heart icon
                        InkWell(
                          onTap: onHeartTap,
                          onDoubleTap: onHeartDoubleTap,
                          child: icon,
                        ),
                        const SizedBox(width: 8),
                        // Reply icon
                        InkWell(
                          onTap: onReplyTap,
                          child: const Icon(Icons.reply, size: 20),
                        ),
                      ],
                    ),
                    reactionsCount != 0
                        ? Row(
                            children: [
                              // Reaction icons
                              ...reactionIcons,
                              // Reactions count
                              Text(
                                '$reactionsCount',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
