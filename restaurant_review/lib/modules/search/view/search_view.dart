import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/cards/search_restaurant_card.dart';
import 'package:restaurant_review/global_widgets/posts/post_item.dart';
import 'package:restaurant_review/global_widgets/restaurants_map/restaurants_map.dart';
import 'package:restaurant_review/global_widgets/user/mini_user_infor.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../controller/search_page_controller.dart';

class SearchView extends GetView<SearchPageController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white.withOpacity(0.7),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.search,
                      color: Color(0xFF9B9B9B),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: FlutterI18n.translate(
                            context, "explore.search_bar_text"),
                        hintStyle: const TextStyle(
                          color: Color(0xFF9B9B9B),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                      ),
                      controller: controller.searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        // Call the search function when the "search" key is pressed
                        controller.searchOnPress();
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showFilterModal(context);
                    },
                    icon: const Icon(
                      Icons.filter_list,
                      color: Color(0xFF9B9B9B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoadingSearchPage.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            color: AppColors.white.withOpacity(0.7),
            child: Column(
              children: [
                // Two buttons always visible at the top
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        return ElevatedButton.icon(
                          onPressed: () {
                            _showFilterModal(context);
                            controller.isMapSelected.value = false;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !controller.isMapSelected.value
                                ? const Color(0xFFFFF9E6)
                                : const Color(0xFFF1F1F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: !controller.isMapSelected.value
                                ? Colors.orange
                                : const Color(0xFF9B9B9B),
                          ),
                          icon: Icon(Icons.filter_list,
                              color: !controller.isMapSelected.value
                                  ? Colors.orange
                                  : const Color(0xFF9B9B9B)),
                          label: Text(controller.getSelectedLabel()),
                        );
                      }),
                      const SizedBox(
                          width: 10), // Optional spacing between buttons
                      Obx(() {
                        return ElevatedButton.icon(
                          onPressed:
                              controller.selectedOption.value == 'restaurant'
                                  ? () {
                                      // Handle Map button press
                                      controller.isMapSelected.value = true;
                                    }
                                  : null, // Disable button if not 'restaurant'
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isMapSelected.value
                                ? const Color(0xFFFFF9E6)
                                : const Color(0xFFF1F1F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: controller.isMapSelected.value
                                ? Colors.orange
                                : const Color(0xFF9B9B9B),
                          ),
                          icon: Icon(Icons.map,
                              color: controller.isMapSelected.value
                                  ? Colors.orange
                                  : const Color(0xFF9B9B9B)),
                          label: Text(FlutterI18n.translate(
                              context, "search_page.map")),
                        );
                      }),
                    ],
                  ),
                ),

                if (controller.isSearchResultEmpty.value)
                  Center(
                    child: Text(
                      FlutterI18n.translate(
                          context, "search_page.nothing_found"),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                else if (controller.isMapSelected.value)
                  Expanded(
                    child: RestaurantsMap(
                        restaurants: controller.restaurantMapList),
                  )
                else
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (controller.selectedOption.value == 'restaurant') {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two restaurants per row
                              // crossAxisSpacing: 5.0, // Horizontal spacing
                              // mainAxisSpacing: 5.0, // Vertical spacing
                              childAspectRatio: 3 /
                                  2.5, // Adjust for restaurant card dimensions
                            ),
                            itemCount: controller.searchResults.length,
                            itemBuilder: (context, index) {
                              final item = controller.searchResults[index];
                              return SearchRestaurantCard(
                                restaurantId: item.id,
                                name: item.name,
                                imageUrl: item.imageUrl,
                                rateAverage: item.rateAverage,
                                provinceId: item.provinceId,
                                districtId: item.districtId,
                                wardId: item.wardId,
                                street: item.street,
                                imageHeight: 110,
                                imageWidth: Get.width / 2 - 10,
                                marginRight: 5,
                                marginLeft: 5,
                                marginBottom: 10,
                              );
                            },
                          );
                        } else if (controller.selectedOption.value == 'user') {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  4, // Four users per row (adjust as needed)
                              childAspectRatio:
                                  8 / 9, // Adjust for user card dimensions
                            ),
                            itemCount: controller.searchResults.length,
                            itemBuilder: (context, index) {
                              final item = controller.searchResults[index];
                              return MiniUserInfor(
                                profileId: item.id!,
                                username: item.username!,
                                avatarUrl: item.avatarUrl!,
                                goToUserDetail: (profileId) => Get.toNamed(
                                    Routes.user,
                                    arguments: {"userId": profileId}),
                              );
                            },
                          );
                        } else if (controller.selectedOption.value == 'post') {
                          return ListView.builder(
                            itemCount: controller.searchResults.length,
                            itemBuilder: (context, index) {
                              final item = controller.searchResults[index];
                              return PostItem(
                                id: item.id,
                                userId: item.userId ?? "",
                                userAvatar: item.avatarUrl ?? "",
                                username: item.username ?? "Unknown User",
                                restaurantId: item.restaurantId ?? 1,
                                restaurantAvatar: item.restaurantImage,
                                restaurantName: item.restaurantName,
                                date: item.createdAt,
                                title: item.title,
                                topic: item.topic,
                                content: item.metadataText,
                                hashtags: item.hashtags ?? [],
                                rateList: item.rateList ?? [],
                                mediaUrls: item.metadataImageList ?? [],
                                isLike: item.isLike,
                                isDislike: item.isDislike,
                                isSaved: item.isSaved,
                                dislikeCount: item.dislikeCount,
                                likeCount: item.likeCount,
                                commentCount: item.commentCount,
                                updateIsSavedInDatabase: (postId, isSaved) {
                                  controller.updateSavedPostInDatabase(
                                      postId, isSaved);
                                },
                                onComment: () =>
                                    print("Comment clicked on ${item.title}"),
                                updateIsLikeInDatabase:
                                    (int postId, bool isLike, bool isDislike) {
                                  controller.updateReactionPostInDatabase(
                                      postId, isLike, isDislike);
                                },
                              );
                            },
                          );
                        } else {
                          return const SizedBox.shrink(); // Fallback
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
        }));
  }

  void _showFilterModal(BuildContext context) {
    // Use the current selectedOption from the controller
    String selectedOption = controller.selectedOption.value;
    // final buttonOptions = ['restaurant', 'user', 'post'];
    // final buttonLabels = {
    //   'restaurant': 'Restaurant',
    //   'user': 'User',
    //   'post': 'Post'
    // };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 190, // Increase modal height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Black border on top of the modal
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4E4E4E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the modal
                          },
                          child: Text(FlutterI18n.translate(
                              context, "search_page.cancel")),
                        ),
                        // Filters Icon and Text in the same row
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              FlutterI18n.translate(
                                  context, "search_page.filter"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            controller.searchOnPress();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFF4C36), // Background color
                            elevation: 0, // No shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                              FlutterI18n.translate(
                                  context, "search_page.search"),
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: controller.filterOptions.map((option) {
                        final isSelected = selectedOption == option['value'];
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedOption = option['value']!;
                            });
                            controller.selectedOption.value = option[
                                'value']!; // Save selected option to controller
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? const Color(0xFFFFF9E6)
                                : Colors.white,
                            foregroundColor: isSelected
                                ? Colors.orange
                                : const Color(0xFF4F4F4F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Color(0xFFEBEBEB)),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            option['label']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12), // Add bottom SizedBox
                ],
              ),
            );
          },
        );
      },
    );
  }
}
