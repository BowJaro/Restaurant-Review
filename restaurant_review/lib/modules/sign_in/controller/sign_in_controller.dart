import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/sign_in/repository/sign_in_repository.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../../../utils/validators.dart';

class SignInController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SignInRepository signInRepository;

  // Email and password controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Obscure password (toggle password visibility)
  var obscurePassword = true.obs;

  SignInController(this.signInRepository);

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Sign-in function
  Future<void> signIn() async {
    if (formKey.currentState?.validate() ?? false) {
      ModalUtils.showLoadingIndicator();
      final response = await signInRepository.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Get.back();

      if (response.isSuccess) {
        Get.offAllNamed(Routes.home);

        userId = await signInRepository.getSessionId();
      } else {
        ModalUtils.showMessageWithTitleModal(
            FlutterI18n.translate(
                Get.context!, "authentication.sign_in_failed"),
            response.message);
      }
      getPermission(fetchNew: true);
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
