import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/modules/permission_request/view/add_permission_request.dart';
import 'package:restaurant_review/modules/permission_request/widget/permission_request_item.dart';

import '../controller/permission_request_controller.dart';

class PermissionRequestView extends GetView<PermissionRequestController> {
  const PermissionRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.white, // Set back icon color to white
        ),
        title: Text(
          FlutterI18n.translate(
              context, "permission_request.permission_request"),
          style: const TextStyle(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const AddPermissionRequest())
                      ?.then((_) => controller.getData());
                },
                icon: const Icon(Icons.add_circle_outline),
                label: Text(FlutterI18n.translate(
                    context, "permission_request.add_permission_request")),
              ),
              controller.isLoading.value == true
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox(),
              const SizedBox(height: 8.0),
              Text(
                "${FlutterI18n.translate(context, "permission_request.pending")} [${controller.pendingRequests.length}]",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              // List of pending permission requests
              ListView.builder(
                  itemCount: controller.pendingRequests.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: PermissionRequestItem(
                          permissionRequestModel:
                              controller.pendingRequests[index]),
                    );
                  }),
              const SizedBox(height: 16.0),

              Text(
                "${FlutterI18n.translate(context, "permission_request.approved")} [${controller.approvedRequests.length}]",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              // List of approved permission requests
              ListView.builder(
                  itemCount: controller.approvedRequests.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: PermissionRequestItem(
                          permissionRequestModel:
                              controller.approvedRequests[index]),
                    );
                  }),
              const SizedBox(height: 16.0),

              Text(
                "${FlutterI18n.translate(context, "permission_request.rejected")} [${controller.rejectedRequests.length}]",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              // List of rejected permission requests
              ListView.builder(
                  itemCount: controller.rejectedRequests.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: PermissionRequestItem(
                          permissionRequestModel:
                              controller.rejectedRequests[index]),
                    );
                  }),
              const SizedBox(height: 16.0),
            ],
          );
        }),
      ),
    );
  }
}
