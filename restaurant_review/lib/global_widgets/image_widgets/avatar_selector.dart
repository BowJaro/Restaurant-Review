import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/image_item.dart';

class AvatarSelectorController extends GetxController {
  final Rx<ImageItem?> avatar = Rx<ImageItem?>(null);

  void setImage(ImageItem item) {
    avatar.value = item;
  }

  void removeImage() {
    avatar.value = null;
  }
}

class AvatarSelectorWidget extends StatelessWidget {
  final AvatarSelectorController controller;
  final double size;
  final ImagePicker _picker = ImagePicker();
  final IconData icon;

  AvatarSelectorWidget({
    super.key,
    required this.controller,
    this.size = 100,
    this.icon = Icons.person,
  });

  Future<void> _onSelectImage() async {
    Get.bottomSheet(
      Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(FlutterI18n.translate(Get.context!, "modal.camera")),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  controller.setImage(ImageItem(file: image));
                }
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(FlutterI18n.translate(Get.context!, "modal.gallery")),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  controller.setImage(ImageItem(file: image));
                }
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onSelectImage,
      child: Obx(() {
        final imageItem = controller.avatar.value;
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Container(
                width: size,
                height: size,
                color: AppColors.shadowGray,
                child: imageItem != null
                    ? (imageItem.file != null
                        ? Image.file(
                            File(imageItem.path),
                            fit: BoxFit.cover,
                            width: size,
                            height: size,
                          )
                        : imageItem.url != ""
                            ? Image.network(
                                baseImageUrl + imageItem.path,
                                fit: BoxFit.cover,
                                width: size,
                                height: size,
                              )
                            : (Icon(Icons.person,
                                size: size * 0.8, color: AppColors.black)))
                    : Icon(icon, size: size * 0.8, color: AppColors.black),
              ),
            ),
            if (imageItem != null && imageItem.url != "")
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: controller.removeImage,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.black,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
