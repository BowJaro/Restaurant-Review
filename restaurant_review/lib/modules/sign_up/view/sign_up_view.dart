import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/buttons/full_width_button.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';
import 'package:restaurant_review/modules/language/widget/language_radio_button.dart';
import 'package:restaurant_review/modules/sign_up/controller/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "authentication.sign_up")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: Get.size.height * 0.8,
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email input
                MyInputField(
                  label: FlutterI18n.translate(context, "authentication.email"),
                  textController: controller.emailController,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),
                // Password input
                MyInputField(
                  label:
                      FlutterI18n.translate(context, "authentication.password"),
                  textController: controller.passwordController,
                  validator: controller.validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                // Confirm Password input
                MyInputField(
                  label: FlutterI18n.translate(
                      context, "authentication.confirm_password"),
                  textController: controller.confirmPasswordController,
                  validator: controller.validateConfirmPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                // Sign up button
                FullWidthButton(
                  title:
                      FlutterI18n.translate(context, "authentication.sign_up"),
                  onPressed: () => controller.signUp(),
                ),
                const SizedBox(height: 24),
                // Already have an account? Sign in button
                RichText(
                  text: TextSpan(
                    text: FlutterI18n.translate(
                        context, "authentication.already_have_account"),
                    style: const TextStyle(color: AppColors.textBlack),
                    children: [
                      TextSpan(
                        text:
                            " ${FlutterI18n.translate(context, "authentication.sign_in")}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            controller.goToSignIn();
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const LanguageRadioButton(),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Allow screen to adjust when keyboard appears
    );
  }
}
