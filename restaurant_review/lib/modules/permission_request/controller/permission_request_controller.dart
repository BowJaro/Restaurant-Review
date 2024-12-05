import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_selector.dart';
import 'package:restaurant_review/global_widgets/locations/address_selector.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/permission_request/model/get_permission_request_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/utils/validators.dart';

import '../model/upload_permission_request_model.dart';
import '../repository/permission_request_repository.dart';

class PermissionRequestController extends GetxController {
  final PermissionRequestRepository repository;
  PermissionRequestController(this.repository);

  RxBool isLoading = true.obs;

  // Separate lists for statuses
  RxList<GetPermissionRequestModel> pendingRequests =
      <GetPermissionRequestModel>[].obs;
  RxList<GetPermissionRequestModel> approvedRequests =
      <GetPermissionRequestModel>[].obs;
  RxList<GetPermissionRequestModel> rejectedRequests =
      <GetPermissionRequestModel>[].obs;

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var streetController = TextEditingController();
  final AddressSelectorController addressSelectorController =
      Get.put(AddressSelectorController());
  final ImageSelectorController imageSelectorController =
      Get.put(ImageSelectorController());
  String permission = "user";
  var selectedPermission = "restaurant".obs;

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    } else {
      await getData();
    }
    isLoading.value = false;
    if (permission == "restaurant") {
      Get.back();
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "permission.your_permission_is_highest_level"));
    }
  }

  Future<void> getData() async {
    final futures = <Future<dynamic>>[
      repository.fetchPermissionRequests(userId!),
      getPermission(),
    ];
    final responses = await Future.wait(futures);
    final response = responses[0];
    permission = responses[1];

    if (response != null) {
      List<GetPermissionRequestModel> permissionRequestList = (response
              as List<dynamic>)
          .map((item) =>
              GetPermissionRequestModel.fromMap(item as Map<String, dynamic>))
          .toList();

      // Split the list by status
      splitRequestsByStatus(permissionRequestList);
    } else {
      // Handle the error or null response
    }
  }

  void splitRequestsByStatus(
      List<GetPermissionRequestModel> permissionRequestList) {
    pendingRequests.value = permissionRequestList
        .where((request) => request.status == "pending")
        .toList();
    approvedRequests.value = permissionRequestList
        .where((request) => request.status == "approved")
        .toList();
    rejectedRequests.value = permissionRequestList
        .where((request) => request.status == "rejected")
        .toList();
  }

  bool validateFields() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        streetController.text.isEmpty ||
        imageSelectorController.imageItems.isEmpty) {
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "error.please_fill_all_required_fields"));
      return false;
    }
    return true;
  }

  String? validatePhone(String? value) {
    return ValidatorUtils.validatePhoneNumber(value);
  }

  void sendPermissionRequest() async {
    if (validateFields()) {
      ModalUtils.showLoadingIndicator();
      await repository.addPermissionRequest(
        UploadPermissionRequestModel(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          street: streetController.text.trim(),
          province: addressSelectorController.selectedProvince.value,
          district: addressSelectorController.selectedDistrict.value,
          ward: addressSelectorController.selectedWard.value,
          permission: selectedPermission.value,
          profileId: userId!,
          imageList: imageSelectorController.imageItems
              .map((item) => item.file ?? item.url)
              .toList(),
        ),
      );
      Get.back();
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "snackbar.success"));
    }
  }
}
