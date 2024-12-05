import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/font_sizes.dart';
import 'package:restaurant_review/global_classes/rate.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_gallery.dart';
import 'package:restaurant_review/global_widgets/ratings/star_rate.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class PostItem extends StatelessWidget {
  final String userAvatar;
  final String username;
  final String restaurantAvatar;
  final String restaurantName;
  final String date;
  final String title; // New
  final String topic; // New
  final String content;
  final List<String> hashtags; // New
  final List<RateModel> rateList;
  // final double tasteRating; // New
  // final double serviceRating; // New
  // final double priceRating; // New
  // final double ambianceRating; // New
  // final double cleanlinessRating; // New
  final List<String> mediaUrls;
  final int reactCount;
  final int commentCount;
  final VoidCallback onReact;
  final VoidCallback onComment;
  final VoidCallback onSave;

  const PostItem({
    super.key,
    required this.userAvatar,
    required this.username,
    required this.restaurantAvatar,
    required this.restaurantName,
    required this.date,
    required this.title,
    required this.topic,
    required this.content,
    required this.hashtags,
    required this.rateList,
    required this.mediaUrls,
    required this.reactCount,
    required this.commentCount,
    required this.onReact,
    required this.onComment,
    required this.onSave,
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
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userAvatar),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(FlutterI18n.translate(
                                  context, "post_item.reviewed")),
                              const SizedBox(width: 4),
                              CircleAvatar(
                                radius: 10,
                                backgroundImage: NetworkImage(restaurantAvatar),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurantName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
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
                          // Handle the report action
                          print("Report button clicked");
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: onReact,
                          icon: const Icon(Icons.favorite_border),
                          color: AppColors.textGray1,
                        ),
                        TextButton(
                          onPressed: onReact,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textGray1, // Text color
                          ),
                          child: Text('$reactCount'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onComment,
                          icon: const Icon(Icons.mode_comment_outlined),
                          color: AppColors.textGray1,
                        ),
                        TextButton(
                          onPressed: onComment,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textGray1, // Text color
                          ),
                          child: Text('$commentCount'),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onSave,
                  icon: const Icon(Icons.bookmark_border),
                  color: AppColors.textGray1,
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
            rate.name,
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
