import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/buttons/full_width_button.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';
import 'package:restaurant_review/modules/language/widget/language_radio_button.dart';
import '../../sign_in/controller/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "authentication.sign_in")),
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
                const SizedBox(height: 24),

                // Sign In button
                FullWidthButton(
                  title:
                      FlutterI18n.translate(context, "authentication.sign_in"),
                  onPressed: () => controller.signIn(),
                ),

                const SizedBox(height: 24),

                // Forgot your password?
                TextButton(
                  onPressed: () {},
                  child: Text(FlutterI18n.translate(
                      context, "authentication.forgot_password")),
                ),

                const SizedBox(height: 16),

                // Don't have an account? Sign Up button
                RichText(
                  text: TextSpan(
                    text: FlutterI18n.translate(
                        context, "authentication.dont_have_account"),
                    style: const TextStyle(color: AppColors.textBlack),
                    children: [
                      TextSpan(
                        text:
                            " ${FlutterI18n.translate(context, "authentication.sign_up")}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            controller.goToSignUp();
                          },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const LanguageRadioButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
