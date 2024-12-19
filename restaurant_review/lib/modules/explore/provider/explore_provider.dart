import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreProvider {
  final SupabaseClient supabase;

  ExploreProvider(this.supabase);

  Future<dynamic> getTopReviewers(int limit) async {
    try {
      final response = await supabase
          .rpc("get_top_reviewers", params: {"user_quality": limit});

      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching newest post details: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching newest post details: $error=========');
      return null;
    }
  }

  Future<dynamic> getPopularRestaurants(int limit) async {
    try {
      final response = await supabase.rpc("get_popular_restaurants",
          params: {"restaurant_quality": limit});

      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching newest post details: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching newest post details: $error=========');
      return null;
    }
  }

  Future<dynamic> getTopRatingRestaurants(int limit) async {
    try {
      final response = await supabase.rpc("get_top_rated_restaurants",
          params: {"restaurant_quality": limit});

      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching newest post details: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching newest post details: $error=========');
      return null;
    }
  }

  Future<dynamic> getNearbyRestaurants(
      double latitude, double longitude, int quantity, double radius) async {
    try {
      final response = await supabase.rpc("find_nearby_restaurants", params: {
        "input_latitude": latitude,
        "input_longitude": longitude,
        "quantity_restaurant": quantity,
        "radius": radius,
      });

      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching nearby restaurant: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching nearby restaurant: $error=========');
      return null;
    }
  }
}
