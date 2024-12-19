// import 'package:flutter/material.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:get/get.dart';
// import 'package:restaurant_review/constants/colors.dart';
// import 'package:restaurant_review/global_widgets/posts/post_item.dart';
// import '../controller/feed_controller.dart';

// class FeedView extends GetView<FeedController> {
//   const FeedView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoadingAccountPage.value) {
//         return Scaffold(
//           appBar: AppBar(),
//           body: const Center(child: CircularProgressIndicator()),
//         );
//       }

//       return Scaffold(
//         backgroundColor: AppColors.pageBgGray, // Page background
//         appBar: AppBar(
//           backgroundColor: AppColors.primary,
//           elevation: 0,
//           title: Text(
//             FlutterI18n.translate(context, "account_page.account"),
//             style: const TextStyle(color: AppColors.white),
//           ),
//           actions: [
//             TextButton.icon(
//               onPressed: () {
//                 // Handle Support action
//               },
//               icon: const Icon(Icons.support_agent, color: AppColors.white),
//               label: Text(
//                 FlutterI18n.translate(context, "account_page.support"),
//                 style: const TextStyle(color: AppColors.white),
//               ),
//             ),
//           ],
//         ),
//         body: ListView.builder(
//           itemCount: controller.postList.length,
//           itemBuilder: (context, index) {
//             final post = controller.postList[index];
//             return PostItem(
//               userAvatar: post.avatarUrl ?? "",
//               username: post.username ?? "Unknown User",
//               restaurantAvatar: post.restaurantImage ?? "",
//               restaurantName: post.restaurantName ?? "Unknown Restaurant",
//               date: post.createdAt,
//               title: post.title,
//               topic: post.topic,
//               content: post.metadataText,
//               hashtags: post.hashtags ?? [],
//               rateList: post.rateList ?? [],
//               mediaUrls: post.metadataImageList ?? [],
//               reactCount: 0, // Replace with actual react count
//               commentCount: 0, // Replace with actual comment count
//               onReact: () => print("React clicked on ${post.title}"),
//               onComment: () => print("Comment clicked on ${post.title}"),
//               onSave: () => print("Save clicked on ${post.title}"),
//             );
//           },
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/posts/post_item.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../controller/feed_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Obx(() {
        if (controller.isLoadingAccountPage.value) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.pageBgGray,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            automaticallyImplyLeading: false, // No default back button
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo Image on the Left
                Image.asset(
                  'assets/logo/tahuRed.png', // Replace with your logo path
                  height: 30,
                ),
                // Centered TabBar
                Expanded(
                  child: TabBar(
                    indicatorColor: AppColors.primary3, // Remove underline
                    labelColor: AppColors.black,
                    unselectedLabelColor: AppColors.tabTextColor1,
                    overlayColor: MaterialStateProperty.all(
                        Colors.transparent), // Remove ripple effect
                    tabs: [
                      Tab(
                        text: FlutterI18n.translate(context, "feed.global"),
                      ),
                      Tab(
                        text: FlutterI18n.translate(context, "feed.following"),
                      ),
                    ],
                  ),
                ),
                // Notification Icon on the Right
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: AppColors.black),
                  onPressed: () {
                    Get.toNamed(Routes.notification);
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Tab 1: Global Feed
              ListView.builder(
                itemCount: controller.globalPostList.length,
                itemBuilder: (context, index) {
                  final post = controller.globalPostList[index];
                  return PostItem(
                    id: post.id,
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
                    isLike: post.isLike,
                    isDislike: post.isDislike,
                    isSaved: post.isSaved,
                    dislikeCount: post.dislikeCount,
                    likeCount:
                        post.likeCount, // Replace with actual react count
                    commentCount:
                        post.commentCount, // Replace with actual comment count
                    updateIsSavedInDatabase: (postId, isSaved) {
                      controller.updateSavedPostInDatabase(postId, isSaved);
                    },
                    onComment: () => print("Comment clicked on ${post.title}"),
                    updateIsLikeInDatabase:
                        (int postId, bool isLike, bool isDislike) {
                      controller.updateReactionPostInDatabase(
                          postId, isLike, isDislike);
                    },
                  );
                },
              ),
              // Tab 2: Following Feed
              ListView.builder(
                itemCount: controller.followingPostList.length,
                itemBuilder: (context, index) {
                  final post = controller.followingPostList[index];
                  return PostItem(
                    id: post.id,
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
                    isLike: post.isLike,
                    isDislike: post.isDislike,
                    isSaved: post.isSaved,
                    dislikeCount: post.dislikeCount,
                    likeCount:
                        post.likeCount, // Replace with actual react count
                    commentCount:
                        post.commentCount, // Replace with actual comment count
                    updateIsSavedInDatabase: (postId, isSaved) {
                      controller.updateSavedPostInDatabase(postId, isSaved);
                    },
                    onComment: () => print("Comment clicked on ${post.title}"),
                    updateIsLikeInDatabase:
                        (int postId, bool isLike, bool isDislike) {
                      controller.updateReactionPostInDatabase(
                          postId, isLike, isDislike);
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
