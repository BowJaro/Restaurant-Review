import 'post_following_model.dart';
import 'restaurant_following_model.dart';
import 'user_following_model.dart';

class FollowingModel {
  final List<RestaurantFollowingModel> restaurants;
  final List<UserFollowingModel> users;
  final List<PostFollowingModel> posts;

  FollowingModel({
    required this.restaurants,
    required this.users,
    required this.posts,
  });

  factory FollowingModel.fromMap(Map<String, dynamic> map) {
    return FollowingModel(
      restaurants: List<RestaurantFollowingModel>.from(
        (map['restaurants'] ?? []).map<RestaurantFollowingModel>(
          (mapRestaurant) => RestaurantFollowingModel.fromMap(
              mapRestaurant as Map<String, dynamic>),
        ),
      ),
      users: List<UserFollowingModel>.from(
        (map['users'] ?? []).map<UserFollowingModel>(
          (mapUser) =>
              UserFollowingModel.fromMap(mapUser as Map<String, dynamic>),
        ),
      ),
      posts: List<PostFollowingModel>.from(
        (map['posts'] ?? []).map<PostFollowingModel>(
          (mapPost) =>
              PostFollowingModel.fromMap(mapPost as Map<String, dynamic>),
        ),
      ),
    );
  }
}
