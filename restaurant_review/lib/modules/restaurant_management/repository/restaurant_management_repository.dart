import '../provider/restaurant_management_provider.dart';

class RestaurantManagementRepository {
  final RestaurantManagementProvider provider;

  RestaurantManagementRepository(this.provider);

  Future<dynamic> getUserRestaurants(String profileId) async {
    return await provider.getUserRestaurants(profileId);
  }

  Future<void> deleteRestaurant(int id) async {
    return await provider.deleteRestaurant(id);
  }
}
