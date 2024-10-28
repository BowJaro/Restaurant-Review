import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../../../utils/validators.dart';

class SignUpController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  // Sign-up function
  void signUp() {
    if (formKey.currentState!.validate()) {
      // Perform sign-up logic
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      print("Sign up with Email: $email, Password: $password");

      // Example: Show a success snackbar after signing up
      Get.snackbar(
          FlutterI18n.translate(Get.context!, "authentication.sign_in"),
          'Successfully signed up as $email');
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
