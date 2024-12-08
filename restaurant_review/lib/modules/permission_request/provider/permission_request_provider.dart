import 'package:restaurant_review/modules/permission_request/model/upload_permission_request_model.dart';
import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PermissionRequestProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();
  PermissionRequestProvider(this.supabase);

  /// Fetch permission requests by profile ID
  Future<dynamic> fetchPermissionRequests(String profileId) async {
    final response = await supabase.rpc('get_permission_requests', params: {
      'p_profile_id': profileId,
    });

    return response;
  }

  Future<void> addPermissionRequest(
      UploadPermissionRequestModel uploadPermissionRequestModel) async {
    List<String> imageUrls = await imageService.uploadImages(
        uploadPermissionRequestModel.imageList, "users");

    try {
      await supabase.rpc('insert_permission_request', params: {
        'p_name': uploadPermissionRequestModel.name,
        'p_province': uploadPermissionRequestModel.province,
        'p_district': uploadPermissionRequestModel.district,
        'p_ward': uploadPermissionRequestModel.ward,
        'p_street': uploadPermissionRequestModel.street,
        'p_phone': uploadPermissionRequestModel.phone,
        'p_permission': uploadPermissionRequestModel.permission,
        'p_image_list': imageUrls,
        'p_profile_id': uploadPermissionRequestModel.profileId,
      });
    } on PostgrestException catch (error) {
      print('=========Error add permission request: ${error.message}=========');
    } catch (error) {
      print('=========Unknown error add permission request: $error=========');
    }
  }
}
