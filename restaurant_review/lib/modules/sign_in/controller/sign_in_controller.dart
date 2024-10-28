import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  void signIn() async {
    if (formKey.currentState!.validate()) {
      ModalUtils.showLoadingIndicator();
      // Perform sign-in logic
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        final User? user = res.user;
        if (user != null) {
          Get.offAllNamed(Routes.home);
        }
      } on AuthException catch (error) {
        Get.back();
        Get.snackbar(
          FlutterI18n.translate(Get.context!, "authentication.sign_in_failed"),
          error.message,
        );
      } catch (error) {
        Get.back();
        Get.snackbar(
          FlutterI18n.translate(Get.context!, "authentication.sign_in_failed"),
          error.toString(),
        );
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

  void goToSignUp() {
    Get.offAllNamed(Routes.signUp);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
