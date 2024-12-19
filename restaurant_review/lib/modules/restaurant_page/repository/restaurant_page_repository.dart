import '../provider/restaurant_page_provider.dart';

class RestaurantPageRepository {
  final RestaurantPageProvider provider;

  RestaurantPageRepository(this.provider);

  Future<dynamic> getRestaurantAndPosts(
      {required int restaurantId, required String profileId}) async {
    return await provider.getRestaurantAndPosts(restaurantId, profileId);
  }

  Future<void> toggleFollowing(
          {required String source,
          required String type,
          required String profileId}) =>
      provider.toggleFollowing(source, type, profileId);
}
