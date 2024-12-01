import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/strings.dart';
import 'package:restaurant_review/global_widgets/cards/mini_post_card.dart';
import 'package:restaurant_review/global_widgets/cards/mini_restaurant_card.dart';
import 'package:restaurant_review/global_widgets/cards/mini_user_card.dart';
import 'package:restaurant_review/modules/following/controller/following_controller.dart';

class FollowingView extends GetView<FollowingController> {
  const FollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, "following.following")),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: FlutterI18n.translate(context, "following.restaurant")),
              Tab(text: FlutterI18n.translate(context, "following.post")),
              Tab(text: FlutterI18n.translate(context, "following.user")),
            ],
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _buildList(
                  context,
                  controller.followingModel.value.restaurants,
                  (item) => RestaurantCard(
                    restaurantId: item.id,
                    imageUrl: item.imageUrl,
                    name: item.name,
                    rateAverage: item.rateAverage,
                    street: item.street,
                    provinceId: item.provinceId.toString(),
                    districtId: item.districtId.toString(),
                    wardId: item.wardId.toString(),
                  ),
                  (item) => controller.removeFollowing(
                    item.id.toString(),
                    TableNameStrings.restaurant,
                  ),
                  TableNameStrings.restaurant,
                ),
                _buildList(
                  context,
                  controller.followingModel.value.posts,
                  (item) => MiniPostCard(
                    id: item.id,
                    name: item.name,
                    imageUrl: item.imageUrl,
                    subtitle: item.author ??
                        FlutterI18n.translate(context, "following.unknown"),
                    viewCount: item.viewCount,
                    topic: item.topic,
                  ),
                  (item) => controller.removeFollowing(
                    item.id.toString(),
                    TableNameStrings.post,
                  ),
                  TableNameStrings.post,
                ),
                _buildList(
                  context,
                  controller.followingModel.value.users,
                  (item) => UserCard(
                    userId: item.id,
                    imageUrl: item.imageUrl,
                    name: item.name,
                    userName: item.username,
                    joinDate: item.joinDate,
                  ),
                  (item) => controller.removeFollowing(
                    item.id,
                    TableNameStrings.user,
                  ),
                  TableNameStrings.user,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList<T>(
    BuildContext context,
    List<T> items,
    Widget Function(T item) cardBuilder,
    void Function(T item) removeCallback,
    String type,
  ) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: ValueKey(item),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await _showRemoveConfirmation(context, type);
          },
          onDismissed: (direction) {
            removeCallback(item);
          },
          background: Container(
            color: AppColors.primary,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(Icons.delete, color: AppColors.white),
          ),
          child: cardBuilder(item),
        );
      },
    );
  }

  Future<bool> _showRemoveConfirmation(
      BuildContext context, String type) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          FlutterI18n.translate(context, "following.remove_following"),
        ),
        content: Text(
          FlutterI18n.translate(context, "following.confirm_unfollow_$type"),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false), // Cancel
            child: Text(FlutterI18n.translate(context, "modal.cancel")),
          ),
          TextButton(
            onPressed: () => Get.back(result: true), // Confirm
            child: Text(FlutterI18n.translate(context, "modal.yes")),
          ),
        ],
      ),
    );
    return result ?? false; // Default to false if dialog is dismissed
  }
}
