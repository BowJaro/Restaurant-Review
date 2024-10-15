import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import '../../../utils/validators.dart';

class SignInController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Email and password controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Obscure password (toggle password visibility)
  var obscurePassword = true.obs;

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Sign-in function
  void signIn() {
    if (formKey.currentState!.validate()) {
      // Perform sign-in logic
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      print("Sign In with Email: $email, Password: $password");

      // Example: Show a success snackbar after signing in
      Get.snackbar(
          FlutterI18n.translate(Get.context!, "authentication.sign_in"),
          'Successfully signed in as $email');
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
