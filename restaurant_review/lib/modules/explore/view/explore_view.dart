import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/cards/mini_explore_restaurant_card.dart';
import 'package:restaurant_review/global_widgets/cards/popular_restaurant_card.dart';
import 'package:restaurant_review/global_widgets/user/mini_user_infor.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../controller/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                snap: true,
                title: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.searchPage,
                      arguments: {'keyWord': ""},
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.search,
                              color: Color(0xFF9B9B9B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Looking for something?",
                                hintStyle: TextStyle(
                                  color: Color(0xFF9B9B9B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              enabled:
                                  false, // Disable typing in this TextField
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.filter_list,
                              color: Color(0xFF9B9B9B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: CustomScrollView(
              slivers: [
                // Popular Restaurants Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          FlutterI18n.translate(
                              context, "explore.popular_restaurants"),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.boldText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.popularRestaurantList.length,
                          itemBuilder: (context, index) {
                            final restaurantItem =
                                controller.popularRestaurantList[index];
                            return PopularRestaurantCard(
                              restaurantId: restaurantItem.id,
                              name: restaurantItem.name,
                              imageUrl: restaurantItem.imageUrl,
                              rateAverage: restaurantItem.rateAverage,
                              provinceId: restaurantItem.provinceId,
                              districtId: restaurantItem.districtId,
                              wardId: restaurantItem.wardId,
                              street: restaurantItem.street,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Top Reviewers Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          FlutterI18n.translate(
                              context, "explore.top_reviewers"),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.boldText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.topReviewerList.length,
                          itemBuilder: (context, index) {
                            final userItem = controller.topReviewerList[index];
                            return MiniUserInfor(
                              profileId: userItem.id!,
                              username: userItem.username!,
                              avatarUrl: userItem.avatarUrl!,
                              goToUserDetail: (profileId) => Get.toNamed(
                                  Routes.user,
                                  arguments: {"userId": profileId}),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // TabBar Section
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: AppColors.primary,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(
                              text: FlutterI18n.translate(
                                  context, "explore.nearby"),
                            ),
                            Tab(
                              text: FlutterI18n.translate(
                                  context, "explore.top_rating"),
                            ),
                            Tab(
                              text: FlutterI18n.translate(
                                  context, "explore.event"),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Nearby Tab
                              Container(
                                color: const Color(
                                    0xFFF5F5F5), // Set a light gray background
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.topNearbyRestaurantList.length,
                                  itemBuilder: (context, index) {
                                    final restaurantItem = controller
                                        .topNearbyRestaurantList[index];
                                    return ExploreRestaurantCard(
                                      restaurantId: restaurantItem.id,
                                      name: restaurantItem.name,
                                      imageUrl: restaurantItem.imageUrl,
                                      rateAverage: restaurantItem.rateAverage,
                                      provinceId: restaurantItem.provinceId,
                                      districtId: restaurantItem.districtId,
                                      wardId: restaurantItem.wardId,
                                      street: restaurantItem.street,
                                      distance: restaurantItem.distance,
                                    );
                                  },
                                ),
                              ),
                              // Top Rating Tab
                              Container(
                                color: const Color(
                                    0xFFF5F5F5), // Set a light gray background
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.topRatingRestaurantList.length,
                                  itemBuilder: (context, index) {
                                    final restaurantItem = controller
                                        .topRatingRestaurantList[index];
                                    return ExploreRestaurantCard(
                                      restaurantId: restaurantItem.id,
                                      name: restaurantItem.name,
                                      imageUrl: restaurantItem.imageUrl,
                                      rateAverage: restaurantItem.rateAverage,
                                      provinceId: restaurantItem.provinceId,
                                      districtId: restaurantItem.districtId,
                                      wardId: restaurantItem.wardId,
                                      street: restaurantItem.street,
                                    );
                                  },
                                ),
                              ),

                              // Event Tab
                              Container(
                                color: Colors.purple,
                                child: const Center(child: Text('Event')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
