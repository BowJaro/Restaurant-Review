import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';

import '../controller/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
          body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                AvatarSelectorWidget(
                  controller: controller.avatarSelectorController,
                  size: 150,
                ),
                Text(controller.email)
              ],
            )),
      ));
    });
  }
}
