import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/image_item.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/brand_detail/model/brand_detail_model.dart';
import 'package:restaurant_review/modules/brand_detail/repository/brand_detail_repository.dart';

class BrandDetailController extends GetxController {
  var isLoading = true.obs;
  late bool isNew;
  int? id;

  final BrandDetailRepository repository;
  final TextEditingController nameController = TextEditingController();
  var description =
      "[{\"insert\":\"${FlutterI18n.translate(Get.context!, "brand_detail.description")}\\n\"}]"
          .obs;
  final AvatarSelectorController avatarSelectorController =
      Get.put(AvatarSelectorController());

  BrandDetailController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    final arguments = Get.arguments;
    isNew = arguments['isNew'] ?? true;
    id = arguments['id'];

    if (!isNew && id != null) {
      await fetchBrand();
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    avatarSelectorController.dispose();
    super.onClose();
  }

  void upsertBrand() async {
    ModalUtils.showLoadingIndicator();
    if (avatarSelectorController.avatar.value != null) {
      BrandDetailModel brandDetailModel = BrandDetailModel(
        id: id,
        name: nameController.text.trim(),
        description: description.value,
        image: avatarSelectorController.avatar.value!.file ??
            avatarSelectorController.avatar.value!.url,
      );
      await repository.upsertBrand(brandDetailModel);

      Get.back();
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "brand_detail.success"));
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.missing_image"));
    }
  }

  Future<void> fetchBrand() async {
    isLoading.value = true;
    final response = await repository.fetchBrand(id!);

    if (response != null) {
      final brandDetailModel = BrandDetailModel.fromMap(response);
      nameController.text = brandDetailModel.name;
      description.value = brandDetailModel.description;
      final ImageItem imageItem = ImageItem(url: brandDetailModel.image);
      avatarSelectorController.setImage(imageItem);
      isLoading.value = false;
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
  }
}
