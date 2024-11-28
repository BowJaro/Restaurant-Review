import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/account/model/account_model.dart';
import 'package:restaurant_review/utils/validators.dart';
import '../../../global_widgets/image_widgets/avatar_selector.dart';
import '../../../global_widgets/modals/modals.dart';
import '../repository/account_repository.dart';

class AccountController extends GetxController {
  final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
  final AccountRepository repository;

  AccountController(this.repository);
  var isLoading = true.obs;

  final AvatarSelectorController avatarSelectorController =
      Get.put(AvatarSelectorController());

  late final String email;
  late final String fullName;

  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var fullNameController = TextEditingController();
  var userNameController = TextEditingController();
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  String avatarUrl = "";

  @override
  void onInit() async {
    super.onInit();

    fetchAccount();
  }

  @override
  void onClose() {
    avatarSelectorController.dispose();
    super.onClose();
  }

  Future<void> fetchAccount() async {
    isLoading.value = true;
    final response = await repository.fetchAccount(userId!);

    if (response != null) {
      final accountModel = AccountModel.fromMap(response);
      avatarUrl = accountModel.image.path;
      email = accountModel.email ?? "";
      emailController.text = accountModel.email ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      userNameController.text = accountModel.email ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      fullName = accountModel.fullName ?? "";
      fullNameController.text = accountModel.fullName ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      phoneController.text = accountModel.phone ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      avatarSelectorController.setImage(accountModel.image);
      isLoading.value = false;
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
  }

  // Validate password using ValidatorUtils
  String? validatePhoneNumber(String? value) {
    return ValidatorUtils.validatePhoneNumber(value);
  }

  String? validateEmail(String? value) {
    return ValidatorUtils.validateEmail(value);
  }

  String? validatePassword(String? value) {
    return ValidatorUtils.validatePassword(value);
  }
}
