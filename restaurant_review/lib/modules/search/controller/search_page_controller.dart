import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/map_restaurant.dart';
import 'package:restaurant_review/modules/explore/model/mini_user_model.dart';
import 'package:restaurant_review/modules/explore/model/popular_restaurant_model.dart';
import 'package:restaurant_review/modules/feed/model/post_detail_model.dart';
import 'package:restaurant_review/modules/search/repository/search_repository.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../../../constants/singleton_variables.dart';

class SearchPageController extends GetxController {
  final SearchRepository repository;
  var isLoadingSearchPage = false.obs;
  var isMapSelected = false.obs;
  RxBool isSearchResultEmpty = false.obs; // New flag

  var restaurantList =
      <PopularRestaurantModel>[].obs; // Assuming Restaurant is a defined model
  var postList = <PostDetail>[].obs; // Assuming Post is a defined model
  var userList = <MiniUserModel>[].obs; // Assuming User is a defined model
  var restaurantMapList =
      <MapRestaurantModel>[].obs; // Assuming User is a defined model

  final searchController = TextEditingController();
  var selectedOption = "restaurant".obs; // Initialize with default value

  // final filterOptions = [
  //   {'value': 'restaurant', 'label': 'Restaurant'},
  //   {'value': 'user', 'label': 'User'},
  //   {'value': 'post', 'label': 'Post'},
  // ];

  final filterOptions = [
    {
      'value': 'restaurant',
      'label': FlutterI18n.translate(Get.context!, "search_page.restaurant"),
    },
    {
      'value': 'user',
      'label': FlutterI18n.translate(Get.context!, "search_page.user"),
    },
    {
      'value': 'post',
      'label': FlutterI18n.translate(Get.context!, "search_page.post"),
    },
  ];

  SearchPageController(this.repository);

  @override
  void onInit() async {
    super.onInit();

    if (userId == null) {
      Get.offAllNamed(Routes.signIn);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> searchByKeyword(
      String filterType, String keyword, String userId) async {
    isLoadingSearchPage.value = true;
    final response =
        await repository.searchByKeyword(filterType, keyword, userId);

    if (response != null && response.isNotEmpty) {
      isSearchResultEmpty.value = false;
      if (filterType == 'restaurant') {
        restaurantList.clear();
        restaurantMapList.clear();
        restaurantList.addAll((response as List<dynamic>)
            .map((item) =>
                PopularRestaurantModel.fromMap(item as Map<String, dynamic>))
            .toList());
        restaurantMapList.addAll((response)
            .map((item) =>
                MapRestaurantModel.fromMap(item as Map<String, dynamic>))
            .toList());
        postList.clear();
        userList.clear();
      } else if (filterType == 'post') {
        postList.clear();
        postList.addAll((response as List<dynamic>)
            .map((item) => PostDetail.fromMap(item as Map<String, dynamic>))
            .toList());
        restaurantList.clear();
        restaurantMapList.clear();
        userList.clear();
      } else if (filterType == 'user') {
        userList.clear();
        userList.addAll((response as List<dynamic>)
            .map((item) => MiniUserModel.fromMap(item as Map<String, dynamic>))
            .toList());
        restaurantList.clear();
        restaurantMapList.clear();
        postList.clear();
      }
    } else {
      userList.clear();
      restaurantList.clear();
      postList.clear();

      isSearchResultEmpty.value = true;
    }
    isLoadingSearchPage.value = false;
  }

  List get searchResults {
    if (selectedOption.value == 'restaurant') return restaurantList;
    if (selectedOption.value == 'post') return postList;
    if (selectedOption.value == 'user') return userList;
    if (isSearchResultEmpty.value) return [];
    return [];
  }

  Future<void> searchOnPress() async {
    final filterType = selectedOption.value;
    final keyword = searchController.text.trim();

    print("keyword response ${filterType}   ${keyword}");

    await searchByKeyword(filterType, keyword, userId!);
  }

  // Find the label corresponding to the selected value
  String getSelectedLabel() {
    return filterOptions.firstWhere(
      (option) => option['value'] == selectedOption.value,
      orElse: () => {'label': 'Unknown'},
    )['label']!; // Fallback to 'Unknown' if no match found
  }

  void updateSavedPostInDatabase(int postId, bool isSaved) {
    if (isSaved == true) {
      repository.insertFollowingPost(userId!, postId.toString());
    } else if (isSaved == false) {
      repository.deleteFollowingPost(userId!, postId.toString());
    }
  }

  void updateReactionPostInDatabase(int postId, bool isLike, bool isDislike) {
    if (isLike == true && isDislike == false) {
      repository.upsertReaction(userId!, 'like', postId);
      print('like post inserted');
    } else if (isLike == false && isDislike == true) {
      repository.upsertReaction(userId!, 'dislike', postId);
      print('dislike post inserted');
    } else if (isLike == false && isDislike == false) {
      repository.deleteReaction(userId!, postId);
      print('delete post inserted');
    }
  }
}
