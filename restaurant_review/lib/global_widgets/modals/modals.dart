import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';

class ModalUtils {
  /// Show a message without title
  static void showMessageModal(String message) {
    showDialog(
      context: Get.context!, // Use GetX context
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Close dialog using GetX
              child: Text(
                MaterialLocalizations.of(Get.context!)
                    .okButtonLabel, // Default localized OK label
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show a message with a title
  static void showMessageWithTitleModal(String title, String message) {
    showDialog(
      context: Get.context!, // Use GetX context
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Close dialog using GetX
              child: Text(
                MaterialLocalizations.of(context)
                    .okButtonLabel, // Default localized OK label
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show a message with title and Yes/Cancel buttons
  static void showMessageWithButtonsModal(
      String title, String message, VoidCallback onYes) {
    showDialog(
      context: Get.context!, // Use GetX context
      barrierDismissible:
          false, // Prevent dismissing without selecting an option
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Close dialog using GetX
              child: Text(
                MaterialLocalizations.of(context)
                    .cancelButtonLabel, // Default localized Cancel label
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog using GetX
                onYes(); // Execute Yes callback
              },
              child: Text(
                MaterialLocalizations.of(context)
                    .okButtonLabel, // Default localized OK label
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show a customizable Snackbar
  static void showSnackbar({
    required String title,
    String? message,
    Color backgroundColor = Colors.redAccent,
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

  /// Show a loading indicator with optional message
  static void showLoadingIndicator() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // Prevent user from dismissing while loading
    );
  }
}
