import '../model/upload_permission_request_model.dart';
import '../provider/permission_request_provider.dart';

class PermissionRequestRepository {
  final PermissionRequestProvider provider;

  PermissionRequestRepository(this.provider);

  Future<dynamic> fetchPermissionRequests(String profileId) async {
    return await provider.fetchPermissionRequests(profileId);
  }

  Future<void> addPermissionRequest(
      UploadPermissionRequestModel uploadPermissionRequestModel) async {
    return await provider.addPermissionRequest(uploadPermissionRequestModel);
  }
}
