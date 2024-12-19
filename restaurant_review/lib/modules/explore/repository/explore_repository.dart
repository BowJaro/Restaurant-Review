import '../provider/explore_provider.dart';

class ExploreRepository {
  final ExploreProvider provider;

  ExploreRepository(this.provider);

  Future<dynamic> getTopReviewers(int limit) async {
    return await provider.getTopReviewers(limit);
  }

  Future<dynamic> getPopularRestaurants(int limit) async {
    return await provider.getPopularRestaurants(limit);
  }

  Future<dynamic> getTopRatingRestaurants(int limit) async {
    return await provider.getTopRatingRestaurants(limit);
  }

  Future<dynamic> getNearbyRestaurants(
      double latitude, double longitude, int quantity, double radius) async {
    return await provider.getNearbyRestaurants(
        latitude, longitude, quantity, radius);
  }
}
