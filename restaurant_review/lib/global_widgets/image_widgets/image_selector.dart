import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_classes/image_item.dart';

class ImageSelectorController extends GetxController {
  final RxList<ImageItem> imageItems = <ImageItem>[].obs;

  ImageSelectorController({List<String>? initialUrls}) {
    if (initialUrls != null) {
      imageItems.addAll(initialUrls.map((url) => ImageItem(url: url)));
    }
  }

  void addImage(ImageItem item) {
    imageItems.add(item);
  }

  void removeImage(int index) {
    if (index >= 0 && index < imageItems.length) {
      imageItems.removeAt(index);
    }
  }

  List<ImageItem> get localImages =>
      imageItems.where((item) => item.isLocal).toList();

  List<ImageItem> get remoteImages =>
      imageItems.where((item) => !item.isLocal).toList();

  setImageList(List<String> urls) {
    imageItems.addAll(urls.map((url) => ImageItem(url: url)));
  }
}

class ImageSelectorWidget extends StatelessWidget {
  final ImageSelectorController controller;
  final double size;
  final ImagePicker _picker = ImagePicker();

  ImageSelectorWidget({
    super.key,
    required this.controller,
    this.size = 100,
  });

  Future<void> _onAddImage() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
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
                  controller.addImage(ImageItem(file: image));
                }
                Get.back(); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text(FlutterI18n.translate(Get.context!, "modal.gallery")),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  controller.addImage(ImageItem(file: image));
                }
                Get.back(); // Close the bottom sheet
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
    final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
    return Row(
      children: [
        GestureDetector(
          onTap: _onAddImage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: size,
              height: size,
              color: AppColors.shadowGray,
              child: const Icon(Icons.add, size: 20, color: AppColors.black),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                textDirection: TextDirection.rtl,
                children: List.generate(controller.imageItems.length, (index) {
                  final imageItem = controller.imageItems[index];
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageItem.file != null
                                ? FileImage(File(imageItem.path))
                                : NetworkImage(baseImageUrl + imageItem.path)
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(index),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
