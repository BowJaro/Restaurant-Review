import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/posts/post_item.dart';
import '../controller/feed_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAccountPage.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.pageBgGray, // Page background
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            FlutterI18n.translate(context, "account_page.account"),
            style: const TextStyle(color: AppColors.white),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                // Handle Support action
              },
              icon: const Icon(Icons.support_agent, color: AppColors.white),
              label: Text(
                FlutterI18n.translate(context, "account_page.support"),
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: controller.postList.length,
          itemBuilder: (context, index) {
            final post = controller.postList[index];
            return PostItem(
              userAvatar: post.avatarUrl ?? "",
              username: post.username ?? "Unknown User",
              restaurantAvatar: post.restaurantImage ?? "",
              restaurantName: post.restaurantName ?? "Unknown Restaurant",
              date: post.createdAt,
              title: post.title,
              topic: post.topic,
              content: post.metadataText,
              hashtags: post.hashtags ?? [],
              rateList: post.rateList ?? [],
              mediaUrls: post.metadataImageList ?? [],
              reactCount: 0, // Replace with actual react count
              commentCount: 0, // Replace with actual comment count
              onReact: () => print("React clicked on ${post.title}"),
              onComment: () => print("Comment clicked on ${post.title}"),
              onSave: () => print("Save clicked on ${post.title}"),
            );
          },
        ),
      );
    });
  }
}
