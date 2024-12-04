import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import '../controller/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAccountPage.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF3F2F7), // Page background
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(FlutterI18n.translate(context, "account_page.account"),
              style: const TextStyle(color: AppColors.white)),
          actions: [
            TextButton.icon(
              onPressed: () {
                // Handle Support action
              },
              icon: const Icon(Icons.support_agent, color: AppColors.white),
              label: Text(
                  FlutterI18n.translate(context, "account_page.support"),
                  style: const TextStyle(color: AppColors.white)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // First Layout
              Container(
                // width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),

              const SizedBox(height: 16), // Space between layouts
            ],
          ),
        ),
      );
    });
  }
}
