import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/buttons/full_width_button.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';

import '../controller/account_controller.dart';

class ChangePasswordView extends GetView<AccountController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingChangePassword.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
              FlutterI18n.translate(context, "account_page.change_password"),
              style: const TextStyle(color: AppColors.white)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                MyInputField(
                  label: FlutterI18n.translate(
                      context, "account_page.current_password"),
                  textController: controller.currentPasswordController,
                  validator: controller.validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                MyInputField(
                  label: FlutterI18n.translate(
                      context, "account_page.new_password"),
                  textController: controller.newPasswordController,
                  validator: controller.validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                MyInputField(
                  label: FlutterI18n.translate(
                      context, "account_page.confirm_password"),
                  textController: controller.confirmPasswordController,
                  validator: controller.validateConfirmPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                FullWidthButton(
                  title: FlutterI18n.translate(
                      context, "account_page.update_password"),
                  onPressed: () {
                    controller.updatePassword();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
