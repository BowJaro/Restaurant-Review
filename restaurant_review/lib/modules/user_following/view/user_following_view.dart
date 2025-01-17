import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/strings.dart';
import 'package:restaurant_review/global_widgets/cards/mini_restaurant_card.dart';
import 'package:restaurant_review/global_widgets/cards/mini_user_card.dart';
import 'package:restaurant_review/modules/user_following/controller/user_following_controller.dart';

class UserFollowingView extends GetView<UserFollowingController> {
  const UserFollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: AppColors.white, // Set back icon color to white
          ),
          title: Text(
            FlutterI18n.translate(context, "account_page.my_following"),
            style: const TextStyle(
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.white, // Color for the selected tab's text
            unselectedLabelColor:
                AppColors.white.withOpacity(0.7), // Color for unselected tabs
            indicatorColor: AppColors.white, // Color for the indicator
            tabs: [
              Tab(text: FlutterI18n.translate(context, "following.restaurant")),
              Tab(text: FlutterI18n.translate(context, "following.user")),
            ],
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Container(
              color: AppColors.pageBgGray,
              child: TabBarView(
                children: [
                  _buildListWrapper(
                    context,
                    controller.followingModel!.value.restaurants,
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
                  _buildListWrapper(
                    context,
                    controller.followingModel!.value.users,
                    (item) => UserCard(
                      userId: item.id,
                      imageUrl: item.imageUrl,
                      name: item.name,
                      userName: item.username,
                      joinDate: item.joinDate,
                      onTap: () => controller.goToUserPage(item.id),
                    ),
                    (item) => controller.removeFollowing(
                      item.id,
                      TableNameStrings.user,
                    ),
                    TableNameStrings.user,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListWrapper<T>(
    BuildContext context,
    List<T> items,
    Widget Function(T item) cardBuilder,
    void Function(T item) removeCallback,
    String type,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getFollowing();
      },
      child: _buildList(context, items, cardBuilder, removeCallback, type),
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
