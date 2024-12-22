import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/utils/validators.dart';
import '../repository/sign_up_repository.dart';

class SignUpController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SignUpRepository signUpRepository;

  SignUpController(this.signUpRepository);

  // Email and password controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  // Obscure password (toggle password visibility)
  var obscurePassword = true.obs;

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> signUp() async {
    if (formKey.currentState?.validate() ?? false) {
      ModalUtils.showLoadingIndicator();
      final response = await signUpRepository.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Get.back();

      if (response.isSuccess) {
        Get.offAllNamed(Routes.home);

        userId = await signUpRepository.getSessionId();
      } else {
        ModalUtils.showMessageWithTitleModal(
            FlutterI18n.translate(
                Get.context!, "authentication.sign_up_failed"),
            response.message);
      }
    }
  }

  // Validate email using ValidatorUtils
  String? validateEmail(String? value) {
    return ValidatorUtils.validateEmail(value);
  }

  // Validate password using ValidatorUtils
  String? validatePassword(String? value) {
    return ValidatorUtils.validatePassword(value);
  }

  // Validate confirm password (matches password)
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(
          Get.context!, "authentication.require_confirm_password");
    }

    if (value != passwordController.text) {
      return FlutterI18n.translate(
          Get.context!, "authentication.invalid_confirm_password");
    }

    return null; // Passwords match
  }

  void goToSignIn() {
    Get.offAllNamed(Routes.signIn);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
