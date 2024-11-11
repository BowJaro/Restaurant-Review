import 'package:restaurant_review/global_classes/mini_brand.dart';
import 'package:restaurant_review/global_classes/mini_restaurant_category.dart';

class DataForNewRestaurantModel {
  final List<MiniBrandModel> brandList;
  final List<MiniRestaurantCategoryModel> restaurantCategoryList;

  DataForNewRestaurantModel(
      {required this.brandList, required this.restaurantCategoryList});

  factory DataForNewRestaurantModel.fromJson(Map<String, dynamic> json) {
    final brandList = List<MiniBrandModel>.from(
        json['brand'].map((x) => MiniBrandModel.fromMap(x)));

    final restaurantCategoryList = List<MiniRestaurantCategoryModel>.from(
        json['restaurant_category']
            .map((x) => MiniRestaurantCategoryModel.fromMap(x)));

    return DataForNewRestaurantModel(
      brandList: brandList,
      restaurantCategoryList: restaurantCategoryList,
    );
  }
}
