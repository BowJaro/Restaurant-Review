import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/font_sizes.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:restaurant_review/global_classes/rate.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_gallery.dart';
import 'package:restaurant_review/global_widgets/ratings/star_rate.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../controller/post_controller.dart';

class PostView extends GetView<PostController> {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.postModel.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: Get.size.width,
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
                              Get.toNamed(Routes.user, arguments: {
                                "userId": controller.postModel.userId
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  controller.postModel.avatarUrl != null
                                      ? NetworkImage(baseImageUrl +
                                          controller.postModel.avatarUrl!)
                                      : null,
                              child: controller.postModel.avatarUrl == null
                                  ? const Icon(Icons.person, size: 20)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.postModel.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                controller.postModel.restaurantName == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            FlutterI18n.translate(
                                                context, "post_item.reviewed"),
                                          ),
                                          const SizedBox(width: 4),
                                          controller.postModel
                                                      .restaurantImage ==
                                                  null
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        Routes.restaurantPage,
                                                        arguments: {
                                                          "id": controller
                                                              .postModel
                                                              .restaurantId
                                                        });
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: NetworkImage(
                                                        baseImageUrl +
                                                            controller.postModel
                                                                .restaurantImage!),
                                                  ),
                                                ),
                                          const SizedBox(width: 4),
                                          controller.postModel.restaurantName ==
                                                  null
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                        Routes.restaurantPage,
                                                        arguments: {
                                                          "id": controller
                                                              .postModel
                                                              .restaurantId
                                                        });
                                                  },
                                                  child: SizedBox(
                                                    width: Get.size.width * 0.4,
                                                    child: Text(
                                                      controller.postModel
                                                          .restaurantName!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          PopupMenuButton(
                                            color: Colors.white,
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: AppColors.textGray1,
                                            ),
                                            onSelected: (value) {
                                              if (value ==
                                                  FlutterI18n.translate(context,
                                                      "post_item.report")) {
                                                controller.openReportPage(
                                                    controller.postModel.id);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: FlutterI18n.translate(
                                                    context,
                                                    "post_item.report"),
                                                child: Text(
                                                    FlutterI18n.translate(
                                                        context,
                                                        "post_item.report")),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.dateToString(controller.postModel.createdAt),
                        style: const TextStyle(
                          color: AppColors.textGray,
                          fontSize: 12,
                        ),
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
                              controller.postModel.title,
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
                              jsonDecode(controller.postModel.content),
                            ),
                            selection: const TextSelection.collapsed(offset: 0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.postModel.hashtags
                            .map((tag) => '#$tag')
                            .join(' '),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [getRatingSection()],
                  ),
                ),

                // Fourth Layout: Media (Images/Videos)
                if (controller.postModel.mediaUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ImageGallery(
                      urls: controller.postModel.mediaUrls,
                    ),
                  ),

                // Fifth Layout: React + Comment + Save Buttons
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => TextButton(
                              onPressed: () {
                                controller.updateReaction(true);
                              },
                              style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    controller.postModel.isLike.value
                                        ? Icons.thumb_up_alt
                                        : Icons.thumb_up_off_alt,
                                    color: controller.postModel.isLike.value
                                        ? AppColors.primary
                                        : AppColors.textGray1,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ), // Add some space between icon and text
                                  Text(
                                    '${controller.postModel.likeCount}',
                                    style: TextStyle(
                                      color: controller.postModel.isLike.value
                                          ? AppColors.primary
                                          : AppColors.textGray1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Obx(
                            () => TextButton(
                              onPressed: () {
                                controller.updateReaction(false);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    controller.postModel.isDislike.value
                                        ? Icons.thumb_down_alt
                                        : Icons.thumb_down_off_alt,
                                    color: controller.postModel.isDislike.value
                                        ? AppColors.primary
                                        : AppColors.textGray1,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ), // Add some space between icon and text
                                  Text(
                                    '${controller.postModel.dislikeCount}',
                                    style: const TextStyle(
                                      color: AppColors.textGray1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              controller
                                  .openCommentPage(controller.postModel.id);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.mode_comment_outlined,
                                  color: AppColors.textGray1,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${controller.postModel.commentCount}',
                                  style: const TextStyle(
                                    color: AppColors.textGray1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => IconButton(
                          onPressed: () {
                            controller.savePost();
                          },
                          icon: Icon(
                            controller.postModel.isSaved.value
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                          ),
                          color: controller.postModel.isSaved.value
                              ? AppColors.primary
                              : AppColors.textGray1,
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
          ),
        ),
      );
    });
  }

  Widget getRatingSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: controller.postModel.rateList.length,
      itemBuilder: (context, index) {
        return getRowRating(
            rate: controller.postModel.rateList[index], isReadOnly: false);
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
