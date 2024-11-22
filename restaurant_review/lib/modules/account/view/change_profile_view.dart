import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/buttons/full_width_button.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';

import '../controller/account_controller.dart';

class ChangeProfileView extends GetView<AccountController> {
  const ChangeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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
              Column(
                children: [
                  AvatarSelectorWidget(
                    controller: controller.avatarSelectorController,
                    size: 150,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  MyInputField(
                    label: FlutterI18n.translate(context, "account_page.email"),
                    textController: controller.emailController,
                    validator: controller.validateEmail,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  MyInputField(
                    label: FlutterI18n.translate(context, "account_page.phone"),
                    textController: controller.phoneController,
                    validator: controller.validatePhoneNumber,
                  ),
                  const SizedBox(height: 10),
                  MyInputField(
                    label: FlutterI18n.translate(
                        context, "account_page.full_name"),
                    textController: controller.fullNameController,
                  ),
                  const SizedBox(height: 10),
                  MyInputField(
                    label: FlutterI18n.translate(
                        context, "account_page.user_name"),
                    textController: controller.userNameController,
                  ),
                  const SizedBox(height: 10),
                  FullWidthButton(
                    title: FlutterI18n.translate(
                        context, "account_page.change_profile"),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      FlutterI18n.translate(
                          context, "account_page.change_password"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}