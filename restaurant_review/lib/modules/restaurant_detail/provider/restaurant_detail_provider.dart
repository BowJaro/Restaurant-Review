import 'package:image_picker/image_picker.dart';

import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/restaurant_upsert_model.dart';

class RestaurantDetailProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();

  RestaurantDetailProvider(this.supabase);

  Future<dynamic> fetchDataForNewRestaurant() async {
    try {
      final response = await supabase.rpc("get_data_for_new_restaurant");
      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching data for new restaurant: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching data for new restaurant: $error=========');
      return null;
    }
  }

  Future<dynamic> fetchRestaurant(int id) async {
    try {
      final response = await supabase.rpc("get_restaurant_details", params: {
        'p_id': id,
      });
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching restaurant: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching restaurant: $error=========');
      return null;
    }
  }

  Future<bool> upsertRestaurant(RestaurantUpsertModel restaurantModel) async {
    List<String> imageUrls = [];
    String avatarUrl = "";

    // Upload each image in imageList
    for (var image in restaurantModel.imageList) {
      String? imageUrl;

      if (image is XFile) {
        imageUrl = await imageService.uploadImage(
          image,
          'images',
          'restaurants/${image.name}',
        );

        if (imageUrl.isEmpty) {
          print('=========Failed to upload image=========');
          return false;
        }
      } else if (image is String) {
        imageUrl = image; // Use the provided URL directly
      } else {
        print('=========Invalid image parameter=========');
        return false;
      }

      imageUrls.add(imageUrl);
    }

    // Check if avatar is a file or a URL
    if (restaurantModel.avatar is XFile) {
      avatarUrl = await imageService.uploadImage(
        restaurantModel.avatar,
        'images',
        'restaurants/${restaurantModel.avatar.name}',
      );

      if (avatarUrl.isEmpty) {
        print('=========Failed to upload avatar=========');
        return false;
      }
    } else if (restaurantModel.avatar is String) {
      avatarUrl = restaurantModel.avatar; // Use the provided URL directly
    }

    try {
      // Call the upsert function
      await supabase.rpc('upsert_restaurant', params: {
        'p_id': restaurantModel.id, // or null if new
        'p_name': restaurantModel.name,
        'p_metadata_id': restaurantModel.metadataId,
        'p_description': restaurantModel.description,
        'p_restaurant_category_id': restaurantModel.restaurantCategoryId,
        'p_brand_id': restaurantModel.brandId,
        'p_hashtag_list': restaurantModel.hashtagList,
        'p_image_urls': imageUrls,
        'p_avatar_id': restaurantModel.avatarId,
        'p_avatar_url': avatarUrl,
        'p_address_id': restaurantModel.addressId,
        'p_province': restaurantModel.province,
        'p_district': restaurantModel.district,
        'p_ward': restaurantModel.ward,
        'p_street': restaurantModel.street,
        'p_location_id': restaurantModel.locationId,
        'p_latitude': restaurantModel.latitude,
        'p_longitude': restaurantModel.longitude,
      });

      return true;
    } on PostgrestException catch (error) {
      print('=========Error upserting restaurant: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error upserting restaurant: $error=========');
    }

    return false;
  }
}
