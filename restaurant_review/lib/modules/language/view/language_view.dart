import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';

import '../controller/language_controller.dart';

class LanguageSelectionView extends GetView<LocaleController> {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'change_language')),
      ),
      body: Column(
        children: [
          Obx(() {
            return RadioListTile(
              value: 'en',
              groupValue: controller.locale.value,
              onChanged: (value) => controller.changeLocale(value.toString()),
              title: Row(
                children: [
                  Image.asset(
                    'assets/icons/usa.jpg',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(FlutterI18n.translate(context, "languages.en")),
                ],
              ),
            );
          }),
          Obx(() {
            return RadioListTile(
              value: 'vi',
              groupValue: controller.locale.value,
              onChanged: (value) => controller.changeLocale(value.toString()),
              title: Row(
                children: [
                  Image.asset(
                    'assets/icons/vn.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(FlutterI18n.translate(context, "languages.vi")),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.defaultDialog(
      title: FlutterI18n.translate(context, 'change_language'),
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              controller.changeLocale('en');
              Get.back();
            },
            child: const Text("English"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.changeLocale('vi');
              Get.back();
            },
            child: const Text("Tiếng Việt"),
          ),
          // Add more languages here
        ],
      ),
    );
  }
}
