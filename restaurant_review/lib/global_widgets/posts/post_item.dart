import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/font_sizes.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/rate.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_gallery.dart';
import 'package:restaurant_review/global_widgets/ratings/star_rate.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:restaurant_review/routes/routes.dart';

class PostItemController extends GetxController {
  Timer? _reactionTimer;
  Timer? _saveTimer;

  @override
  void onClose() {
    _reactionTimer?.cancel();
    _saveTimer?.cancel();
    super.onClose();
  }

  void openReportPage(int postId) {
    Get.toNamed(Routes.report,
        arguments: {"type": "post", "source": postId.toString()});
  }

  void openCommentPage(int postId) {
    Get.toNamed(Routes.comment, arguments: {"post_id": postId});
  }
}

class PostItem extends StatelessWidget {
  final int id;
  final String userId;
  final String userAvatar;
  final String username;
  final int? restaurantId;
  final String? restaurantAvatar;
  final String? restaurantName;
  final String date;
  final String title; // New
  final String topic; // New
  final String content;
  final List<String> hashtags; // New
  final List<RateModel> rateList;
  final List<String> mediaUrls;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final RxBool isSaved; // Accept RxBool
  final RxBool isLike;
  final RxBool isDislike;
  final VoidCallback onComment;
  final void Function(int, bool) updateIsSavedInDatabase;
  final void Function(int, bool, bool) updateIsLikeInDatabase;

  final PostItemController controller = Get.put(PostItemController());

  PostItem({
    super.key,
    required this.id,
    required this.userId,
    required this.userAvatar,
    required this.username,
    required this.restaurantId,
    required this.restaurantAvatar,
    required this.restaurantName,
    required this.date,
    required this.title,
    required this.topic,
    required this.content,
    required this.hashtags,
    required this.rateList,
    required this.mediaUrls,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
    required this.isSaved,
    required this.isLike,
    required this.isDislike,
    required this.onComment,
    required this.updateIsLikeInDatabase,
    required this.updateIsSavedInDatabase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Full width of the screen
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Layout: User Info + Restaurant Info + More Icon
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.user,
                          arguments: {'userId': userId},
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(baseImageUrl + userAvatar),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.user,
                                arguments: {'userId': userId},
                              );
                            },
                            child: Text(
                              username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (restaurantAvatar != null ||
                              restaurantName != null)
                            Row(
                              children: [
                                Text(FlutterI18n.translate(
                                    context, "post_item.reviewed")),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.restaurantPage,
                                        arguments: {'id': restaurantId});
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundImage:
                                            restaurantAvatar != null
                                                ? NetworkImage(baseImageUrl +
                                                    restaurantAvatar!)
                                                : null,
                                      ),
                                      const SizedBox(width: 4),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxWidth:
                                                160), // adjust the width as needed
                                        child: Text(
                                          restaurantName ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      color: Colors.white,
                      icon: const Icon(Icons.more_vert,
                          color: AppColors.textGray1),
                      onSelected: (value) {
                        if (value ==
                            FlutterI18n.translate(
                                context, "post_item.report")) {
                          controller.openReportPage(id);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: FlutterI18n.translate(
                              context, "post_item.report"),
                          child: Text(
                            FlutterI18n.translate(context, "post_item.report"),
                            style: const TextStyle(
                                color: Colors.black), // Text color
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),

          // Second Layout: Post Title, Topic, Content, Hashtags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AbsorbPointer(
                  child: quill.QuillEditor.basic(
                    controller: quill.QuillController(
                      document: quill.Document.fromJson(
                        jsonDecode(content),
                      ),
                      selection: const TextSelection.collapsed(offset: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hashtags.map((tag) => '#$tag').join(' '),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Third Layout: Ratings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [getRatingSection()],
            ),
          ),

          // Fourth Layout: Media (Images/Videos)
          if (mediaUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ImageGallery(urls: mediaUrls),
            ),

          // Fifth Layout: React + Comment + Save Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(() => TextButton(
                          onPressed: () {
                            isLike.value = !isLike.value;
                            if (isLike.value) {
                              isDislike.value = false;
                            }
                            controller._reactionTimer
                                ?.cancel(); // Cancel any existing timer
                            controller._reactionTimer =
                                Timer(const Duration(seconds: 3), () {
                              updateIsLikeInDatabase(
                                  id, isLike.value, isDislike.value);
                            });
                          },
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isLike.value
                                    ? Icons.thumb_up_alt
                                    : Icons.thumb_up_off_alt,
                                color: isLike.value
                                    ? AppColors.primary
                                    : AppColors.textGray1,
                              ),
                              const SizedBox(
                                  width:
                                      5), // Add some space between icon and text
                              Text(
                                '$likeCount',
                                style: TextStyle(
                                  color: isLike.value
                                      ? AppColors.primary
                                      : AppColors.textGray1,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 16),
                    Obx(() => TextButton(
                          onPressed: () {
                            isDislike.value = !isDislike.value;
                            if (isDislike.value) {
                              isLike.value = false;
                            }

                            controller._reactionTimer
                                ?.cancel(); // Cancel any existing timer
                            controller._reactionTimer =
                                Timer(const Duration(seconds: 3), () {
                              updateIsLikeInDatabase(
                                  id, isLike.value, isDislike.value);
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                isDislike.value
                                    ? Icons.thumb_down_alt
                                    : Icons
                                        .thumb_down_off_alt, // Change icon based on state
                                color: isDislike.value
                                    ? AppColors.primary
                                    : AppColors.textGray1,
                              ),
                              const SizedBox(
                                  width:
                                      5), // Add some space between icon and text
                              Text(
                                '$dislikeCount',
                                style: const TextStyle(
                                  color: AppColors.textGray1,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 16),
                    TextButton(
                        onPressed: () {
                          controller.openCommentPage(id);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.mode_comment_outlined,
                              color: AppColors.textGray1,
                            ),
                            const SizedBox(width: 4),
                            Text('$commentCount',
                                style: const TextStyle(
                                  color: AppColors.textGray1,
                                )),
                          ],
                        )),
                  ],
                ),
                Obx(
                  () => IconButton(
                    onPressed: () {
                      isSaved.value = !isSaved.value;
                      controller._saveTimer
                          ?.cancel(); // Cancel any existing timer
                      controller._saveTimer =
                          Timer(const Duration(seconds: 3), () {
                        updateIsSavedInDatabase(id, isSaved.value);
                      });
                    },
                    icon: Icon(
                      isSaved.value ? Icons.bookmark : Icons.bookmark_border,
                    ),
                    color:
                        isSaved.value ? AppColors.primary : AppColors.textGray1,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Line Separator
          const Divider(
            height: 1,
            color: AppColors.dividerGray,
          ),
        ],
      ),
    );
  }

  Widget getRatingSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: rateList.length,
      itemBuilder: (context, index) {
        return getRowRating(rate: rateList[index], isReadOnly: false);
      },
    );
  }

  Widget getRowRating(
      {required RateModel rate, bool isReadOnly = false, double size = 23}) {
    double width = Get.size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: width * 0.3,
          child: Text(
            FlutterI18n.translate(
                Get.context!, "post_detail.${rate.name.toLowerCase()}"),
            style: const TextStyle(fontSize: AppFontSizes.s7),
          ),
        ),
        SizedBox(
          width: width * 0.5,
          child: Obx(() {
            return StarRating(
              value: rate.value.value,
              size: size,
            );
          }),
        ),
      ],
    );
  }
}
