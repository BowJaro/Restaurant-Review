import '../model/restaurant_upsert_model.dart';
import '../provider/restaurant_detail_provider.dart';

class RestaurantDetailRepository {
  final RestaurantDetailProvider provider;

  RestaurantDetailRepository(this.provider);

  Future<dynamic> fetchDataForNewRestaurant() async {
    return await provider.fetchDataForNewRestaurant();
  }

  Future<dynamic> fetchRestaurant(int id) async {
    return await provider.fetchRestaurant(id);
  }

  Future<bool> upsertRestaurant(RestaurantUpsertModel restaurantModel) async {
    return await provider.upsertRestaurant(restaurantModel);
  }
}
