import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/image_item.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../model/menu_creation_model.dart';
import '../repository/menu_creation_repository.dart';
import '../view/update_menu_item.dart';

class MenuCreationController extends GetxController {
  final MenuCreationRepository repository;
  MenuCreationController(this.repository);

  var isLoading = true.obs;
  final int? restaurantId = Get.arguments['restaurantId'];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  late AvatarSelectorController avatarSelectorController;

  RxList<MenuCreationModel> menuList = <MenuCreationModel>[].obs;
  List<int> removedMenuIdList = [];

  @override
  void onInit() async {
    super.onInit();
    Get.create(() => AvatarSelectorController());
    avatarSelectorController = Get.find<AvatarSelectorController>();

    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }

    if (restaurantId == null) {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "menu_creation.not_exist"));
      return;
    }

    await getData();
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    avatarSelectorController.dispose();
    super.onClose();
  }

  Future<void> getData() async {
    final response = await repository.getMenuItems(restaurantId!);
    if (response != null) {
      menuList = (response as List<dynamic>)
          .map((item) => MenuCreationModel.fromMap(item))
          .toList()
          .obs;
    }
  }

  Future<void> createMenuItem() async {
    if (menuList.isNotEmpty) {
      ModalUtils.showLoadingIndicator();
      await Future.wait([
        repository.upsertMenuItems(restaurantId!, menuList),
        repository.removeMenuItems(removedMenuIdList),
      ]);
      removedMenuIdList.clear();
      Get.back();
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "menu_creation.success"));
    } else {
      Get.back();
    }
  }

  void addMenuToList() {
    if (validate() == false) {
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "error.please_fill_all_required_fields"));
      return;
    }

    dynamic image;
    if (avatarSelectorController.avatar.value!.file is XFile) {
      image = ImageItem(file: avatarSelectorController.avatar.value!.file);
    } else if (avatarSelectorController.avatar.value!.url is String) {
      image = ImageItem(url: avatarSelectorController.avatar.value!.url);
    }

    menuList.add(
      MenuCreationModel(
        id: null,
        name: nameController.text.trim().obs,
        description: descriptionController.text.trim().obs,
        price: double.parse(priceController.text.trim() == ""
                ? "0"
                : priceController.text.trim())
            .obs,
        image: Rx<ImageItem>(image),
      ),
    );

    clearInputField();
  }

  void removeMenu(int index) {
    if (menuList[index].id != null) {
      removedMenuIdList.add(menuList[index].id!);
    }
    menuList.removeAt(index);
  }

  bool validate() {
    return !(nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        avatarSelectorController.avatar.value == null);
  }

  void goToUpdateMenu(int index) async {
    nameController.text = menuList[index].name.value;
    descriptionController.text = menuList[index].description.value;
    priceController.text = menuList[index].price.value.toString();

    if (menuList[index].image.value.url is String) {
      avatarSelectorController
          .setImage(ImageItem(url: menuList[index].image.value.url));
    } else if (menuList[index].image.value.file is XFile) {
      avatarSelectorController
          .setImage(ImageItem(file: menuList[index].image.value.file));
    }

    Get.to(() => UpdateMenuItem(
          index: index,
        ));
  }

  void updateMenu(int index) {
    if (validate() == false) {
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "error.please_fill_all_required_fields"));
      return;
    }

    dynamic image;
    if (avatarSelectorController.avatar.value!.url is String) {
      image = ImageItem(url: avatarSelectorController.avatar.value!.url);
    } else if (avatarSelectorController.avatar.value!.file is XFile) {
      image = ImageItem(file: avatarSelectorController.avatar.value!.file);
    }

    menuList[index].name.value = nameController.text.trim();
    menuList[index].description.value = descriptionController.text.trim();
    menuList[index].price.value = double.parse(
        priceController.text.trim() == "" ? "0" : priceController.text.trim());
    menuList[index].image = Rx<ImageItem>(image);

    clearInputField();
    Get.back();
  }

  void clearInputField() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    avatarSelectorController.removeImage();
  }
}
