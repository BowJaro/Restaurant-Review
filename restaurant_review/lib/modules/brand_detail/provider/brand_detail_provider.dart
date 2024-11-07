import 'package:restaurant_review/modules/brand_detail/model/brand_detail_model.dart';
import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class BrandDetailProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();

  BrandDetailProvider(this.supabase);

  Future<bool> upsertBrand(BrandDetailModel brandDetailModel) async {
    String? imageUrl;

    // Check if image is a file or a URL
    if (brandDetailModel.image is XFile) {
      imageUrl = await imageService.uploadImage(
        brandDetailModel.image,
        'images',
        'brands/${brandDetailModel.image.name}',
      );

      if (imageUrl.isEmpty) {
        print('=========Failed to upload image=========');
        return false;
      }
    } else if (brandDetailModel.image is String) {
      imageUrl = brandDetailModel.image; // Use the provided URL directly
    } else {
      print('=========Invalid image parameter=========');
      return false;
    }

    // Call the upsert function
    await supabase.rpc('upsert_brand', params: {
      'p_id': brandDetailModel.id, // or null if new
      'p_name': brandDetailModel.name,
      'p_description': brandDetailModel.description,
      'p_image_url': imageUrl,
    });

    return true;
  }

  Future<dynamic> fetchBrand(int id) async {
    try {
      final response =
          await supabase.rpc("fetch_brand_detail", params: {"p_id": id});
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching brand: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching brand: $error=========');
      return null;
    }
  }
}
