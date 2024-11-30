import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/modules/account/model/account_model.dart';
import 'package:restaurant_review/modules/account/model/account_update_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/utils/validators.dart';
import '../../../constants/singleton_variables.dart';
import '../../../global_widgets/image_widgets/avatar_selector.dart';
import '../../../global_widgets/modals/modals.dart';
import '../repository/account_repository.dart';

class AccountController extends GetxController {
  final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
  final AccountRepository repository;

  AccountController(this.repository);
  var isLoadingAccountPage = true.obs;
  var isLoadingChangeProfile = false.obs;
  var isLoadingChangePassword = false.obs;

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
  var updateEmailController = TextEditingController();

  // Statistics
  var reviews = 0.obs; // Number of reviews
  var followers = 0.obs; // Number of followers
  var following = 0.obs; // Number of people the user is following

  String avatarUrl = "";

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.signIn);
    }
    fetchAccount();
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    avatarSelectorController.dispose();
    super.onClose();
  }

  Future<void> fetchAccount() async {
    isLoadingAccountPage.value = true;
    final response = await repository.fetchAccount(userId!);

    reviews.value = 25;
    followers.value = 150;
    following.value = 75;
    if (response != null) {
      final accountModel = AccountModel.fromMap(response);
      avatarUrl = accountModel.image.path;
      email = accountModel.email ?? "";
      emailController.text = accountModel.email ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      userNameController.text = accountModel.userName ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      fullName = accountModel.fullName ?? "";
      fullNameController.text = accountModel.fullName ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      phoneController.text = accountModel.phone ??
          FlutterI18n.translate(Get.context!, "error.no_data");
      avatarSelectorController.setImage(accountModel.image);
      isLoadingAccountPage.value = false;
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
  }

  // Method to update the profile
  Future<void> updateAccount() async {
    isLoadingChangeProfile.value = true;
    AccountUpdateModel accountUpdateModel = AccountUpdateModel(
        userId: userId!,
        userName: userNameController.text,
        fullName: fullNameController.text,
        phone: phoneController.text,
        imageUrl: avatarSelectorController.avatar.value!.file ??
            avatarSelectorController.avatar.value!.url);

    final success = await repository.updateAccount(accountUpdateModel);

    if (success == true) {
      ModalUtils.showSnackbar(
        title: FlutterI18n.translate(Get.context!, "snackbar.success"),
        message: FlutterI18n.translate(
            Get.context!, "account_page.update_acc_success"),
        backgroundColor: Colors.blue.shade700,
      );
    } else {
      ModalUtils.showSnackbar(
        title: FlutterI18n.translate(Get.context!, "snackbar.error"),
        message:
            FlutterI18n.translate(Get.context!, "account_page.update_acc_fail"),
      );
    }

    isLoadingChangeProfile.value = false;
  }

  // Function to save the updated email
  Future<void> updateEmail() async {
    final success = await repository.updateEmail(emailController.text, userId!);
    if (success != null) {
      ModalUtils.showSnackbar(
        title: FlutterI18n.translate(Get.context!, "snackbar.success"),
        message: FlutterI18n.translate(
            Get.context!, "account_page.update_acc_success"),
        backgroundColor: Colors.blue.shade700,
      );
    } else {
      ModalUtils.showSnackbar(
        title: FlutterI18n.translate(Get.context!, "snackbar.error"),
        message:
            FlutterI18n.translate(Get.context!, "account_page.update_acc_fail"),
      );
    }
  }

  Future<void> updatePassword() async {
    isLoadingChangePassword.value = true;
    //  check current password
    final response = await repository.verifyPassword(
        currentPasswordController.text, userId!);

    if (response == true) {
      // check confirm password
      final success =
          await repository.updatePassword(newPasswordController.text);

      if (success != null) {
        ModalUtils.showSnackbar(
          title: FlutterI18n.translate(Get.context!, "snackbar.success"),
          message: FlutterI18n.translate(
              Get.context!, "account_page.update_acc_success"),
          backgroundColor: Colors.blue.shade700,
        );
      } else {
        ModalUtils.showSnackbar(
          title: FlutterI18n.translate(Get.context!, "snackbar.error"),
          message: FlutterI18n.translate(
              Get.context!, "account_page.update_acc_fail"),
        );
      }
    } else {
      // Handle incorrect current password
      ModalUtils.showSnackbar(
        title: FlutterI18n.translate(Get.context!, "snackbar.error"),
        message:
            FlutterI18n.translate(Get.context!, "account_page.wrong_password"),
      );
    }

    isLoadingChangePassword.value = false;
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

  // Validate confirm password (matches password)
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(
          Get.context!, "authentication.require_confirm_password");
    }

    if (value != newPasswordController.text) {
      return FlutterI18n.translate(
          Get.context!, "authentication.invalid_confirm_password");
    }

    return null; // Passwords match
  }
}
