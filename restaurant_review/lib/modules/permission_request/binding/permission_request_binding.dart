import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/permission_request_controller.dart';
import '../provider/permission_request_provider.dart';
import '../repository/permission_request_repository.dart';

class PermissionRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionRequestProvider>(
        () => PermissionRequestProvider(supabase));
    Get.lazyPut<PermissionRequestRepository>(() =>
        PermissionRequestRepository(Get.find<PermissionRequestProvider>()));
    Get.lazyPut<PermissionRequestController>(() =>
        PermissionRequestController(Get.find<PermissionRequestRepository>()));
  }
}
