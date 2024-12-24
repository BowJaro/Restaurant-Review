import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';
import 'package:restaurant_review/global_widgets/locations/address_selector.dart';

import '../controller/permission_request_controller.dart';

class AddPermissionRequest extends GetView<PermissionRequestController> {
  const AddPermissionRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailPageAppBar(
        title: FlutterI18n.translate(
            context, "permission_request.permission_request"),
        buttonLabel: FlutterI18n.translate(context, "permission_request.send"),
        onPressed: () {
          controller.sendPermissionRequest();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${FlutterI18n.translate(context, "permission_request.current_permission_is")} ${FlutterI18n.translate(context, "permission_request.${controller.permission}_permission")}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.selectedPermission.value = "restaurant";
                    },
                    child: Text(FlutterI18n.translate(
                        context, "permission_request.restaurant_permission")),
                  ),
                  const SizedBox(width: 8.0),
                  controller.permission == "user"
                      ? ElevatedButton(
                          onPressed: () {
                            controller.selectedPermission.value = "reviewer";
                          },
                          child: Text(FlutterI18n.translate(context,
                              "permission_request.reviewer_permission")),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Obx(() {
              return Text(
                  "${FlutterI18n.translate(context, "permission_request.add_permission_request")}: ${FlutterI18n.translate(context, "permission_request.${controller.selectedPermission.value}_permission")}");
            }),
            const SizedBox(height: 10.0),
            MyInputField(
              label: FlutterI18n.translate(context, "permission_request.name"),
              textController: controller.nameController,
            ),
            const SizedBox(height: 10.0),
            MyInputField(
              label: FlutterI18n.translate(context, "permission_request.phone"),
              textController: controller.phoneController,
              validator: controller.validatePhone,
            ),
            const SizedBox(height: 10.0),
            Text(
                "${FlutterI18n.translate(context, "permission_request.proofs")}:"),
            const SizedBox(height: 10.0),
            ImageSelectorWidget(controller: controller.imageSelectorController),
            const SizedBox(height: 10.0),
            Text(
                "${FlutterI18n.translate(context, "permission_request.address")}:"),
            const SizedBox(height: 10.0),
            AddressSelectorView(
                controller: controller.addressSelectorController),
            const SizedBox(height: 10.0),
            MyInputField(
              label:
                  FlutterI18n.translate(context, "permission_request.street"),
              textController: controller.streetController,
            ),
          ],
        ),
      ),
    );
  }
}
