import 'package:restaurant_review/global_classes/full_brand.dart';
import 'package:restaurant_review/global_classes/restaurant_card_model.dart';

class GetRestaurantManagementModel {
  final BrandModel? brand;
  final List<RestaurantCardModel> restaurantList;

  GetRestaurantManagementModel({
    required this.brand,
    required this.restaurantList,
  });

  factory GetRestaurantManagementModel.fromMap(Map<String, dynamic> map) {
    return GetRestaurantManagementModel(
      brand: map['brand'] == null
          ? null
          : BrandModel.fromMap(map['brand'] as Map<String, dynamic>),
      restaurantList: map['restaurant_list'] == null
          ? []
          : List<RestaurantCardModel>.from(
              map['restaurant_list'].map((x) =>
                  RestaurantCardModel.fromJson(x as Map<String, dynamic>)),
            ),
    );
  }
}
