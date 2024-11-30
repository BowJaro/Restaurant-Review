import 'package:restaurant_review/global_classes/restaurant_card_model.dart';

class BrandPageModel {
  String name;
  String description;
  String imageUrl;
  List<RestaurantCardModel> restaurantList;

  BrandPageModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.restaurantList,
  });

  factory BrandPageModel.fromMap(Map<String, dynamic> map) {
    return BrandPageModel(
      name: map['name'],
      description: map['description'],
      imageUrl: map['image_url'],
      restaurantList: (map['restaurant_list'] as List<dynamic>?)
              ?.map((x) =>
                  RestaurantCardModel.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
