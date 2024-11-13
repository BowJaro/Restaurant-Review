import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/modules/post_detail/model/post_with_rate_upsert_model.dart';
import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/post_upsert_model.dart';

class PostDetailProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();

  PostDetailProvider(this.supabase);

  Future<dynamic> fetchDataForNewPost() async {
    try {
      final response = await supabase.rpc("get_data_for_new_post");
      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching data for new post: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching data for new post: $error=========');
      return null;
    }
  }

  Future<dynamic> fetchDataForPostEdit(int id) async {
    try {
      final response = await supabase.rpc("fetch_data_for_post_edit", params: {
        'p_id': id,
      });
      return response;
    } on PostgrestException catch (error) {
      print(
          '=========Error fetching data for post edit: ${error.message}=========');
      return null;
    } catch (error) {
      print(
          '=========Unknown error fetching data for post edit: $error=========');
      return null;
    }
  }

  Future<dynamic> upsertPost(PostUpsertModel postUpsertModel) async {
    List<String> imageUrls = [];

    // Upload each image in imageList
    for (var image in postUpsertModel.imageList) {
      String? imageUrl;

      if (image is XFile) {
        imageUrl = await imageService.uploadImage(
          image,
          'images',
          'posts/${image.name}',
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

    try {
      await supabase.rpc('upsert_post', params: {
        'p_id': postUpsertModel.id,
        'p_topic_id': postUpsertModel.topicId,
        'p_name': postUpsertModel.name,
        'p_metadata_id': postUpsertModel.metadataId,
        'p_content': postUpsertModel.content,
        'p_hashtag_list': postUpsertModel.hashtagList,
        'p_image_url_list': imageUrls,
        'p_profile_id': postUpsertModel.profileId,
        'p_restaurant_id': postUpsertModel.restaurantId,
      });
      return true;
    } on PostgrestException catch (error) {
      print('=========Error upsert post: ${error.message}=========');
      return false;
    } catch (error) {
      print('=========Unknown error upsert post: $error=========');
      return false;
    }
  }

  Future<dynamic> upsertPostWithRate(
      PostWithRateUpsertModel postWithRateModel) async {
    List<String> imageUrls = [];

    // Upload each image in imageList
    for (var image in postWithRateModel.imageList) {
      String? imageUrl;

      if (image is XFile) {
        imageUrl = await imageService.uploadImage(
          image,
          'images',
          'posts/${image.name}',
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
    print("This is imageUrls $imageUrls");

    try {
      await supabase.rpc('upsert_post_with_rate', params: {
        'p_id': postWithRateModel.id,
        'p_topic_id': postWithRateModel.topicId,
        'p_name': postWithRateModel.name,
        'p_metadata_id': postWithRateModel.metadataId,
        'p_content': postWithRateModel.content,
        'p_hashtag_list': postWithRateModel.hashtagList,
        'p_image_url_list': imageUrls,
        'p_profile_id': postWithRateModel.profileId,
        'p_restaurant_id': postWithRateModel.restaurantId,
        'p_rate_id': postWithRateModel.rateId,
        'p_rate_list':
            postWithRateModel.rateList.map((rate) => rate.toMap()).toList(),
      });
      return true;
    } on PostgrestException catch (error) {
      print('=========Error upsert post with rate: ${error.message}=========');
      return false;
    } catch (error) {
      print('=========Unknown error upsert post with rate: $error=========');
      return false;
    }
  }
}
