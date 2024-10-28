import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';

class ModalUtils {
  /// Show a message without title
  static void showMessageModal(String message) {
    Get.defaultDialog(
      title: '',
      contentPadding: const EdgeInsets.all(20),
      barrierDismissible: true,
      content: GestureDetector(
        onTap: () => Get.back(),
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.close, color: AppColors.textGray),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      radius: 10,
    );
  }

  /// Show a message with a title
  static void showMessageWithTitleModal(String title, String message) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.all(20),
      barrierDismissible: true,
      content: GestureDetector(
        onTap: () => Get.back(),
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.close, color: AppColors.textGray),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      radius: 10,
    );
  }

  /// Show a message with title and Yes/Cancel buttons
  static void showMessageWithButtonsModal(
      String title, String message, VoidCallback onYes) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.all(20),
      barrierDismissible: false, // User has to choose an option
      content: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      backgroundColor: AppColors.white,
      radius: 10,
      confirm: ElevatedButton(
        onPressed: onYes,
        child: const Text('Yes'),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.textGray),
        child: const Text('Cancel'),
      ),
    );
  }

  /// Show a customizable Snackbar
  static void showSnackbar({
    required String title,
    String? message,
    Color backgroundColor = AppColors.errorRed,
    Color textColor = AppColors.white,
    SnackPosition snackPosition = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message ?? '', // Optional message, will be empty if not provided
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
