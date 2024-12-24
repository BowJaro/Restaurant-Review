import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/buttons/full_width_button.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';
import 'package:restaurant_review/modules/account/view/change_password_view.dart';
import 'package:restaurant_review/modules/account/view/email_update_modal_view.dart';

import '../controller/account_controller.dart';

class ChangeProfileView extends GetView<AccountController> {
  const ChangeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingChangeProfile.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColors.white, // Set back icon color to white
          ),
          backgroundColor: AppColors.primary,
          title: Text(
              FlutterI18n.translate(context, "account_page.change_profile"),
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
                    // Email section
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              MyInputField(
                                label: FlutterI18n.translate(
                                    context, "account_page.email"),
                                textController: controller.emailController,
                                validator: controller.validateEmail,
                                readOnly: true,
                              ),
                              Positioned(
                                right:
                                    0, // Adjust this value to position the icon horizontally
                                top:
                                    4, // Adjust this value to position the icon vertically
                                child: IconButton(
                                  icon: const Icon(
                                    Icons
                                        .edit, // Change icon based on email edit state
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    Get.dialog(
                                        const EmailUpdateModalView()); // Open modal
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyInputField(
                      label:
                          FlutterI18n.translate(context, "account_page.phone"),
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
                      onPressed: () {
                        controller.updateAccount();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const ChangePasswordView());
                      },
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
    });
  }
}
