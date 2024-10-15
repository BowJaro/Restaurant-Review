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
        title: Text(FlutterI18n.translate(context, 'welcome')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(FlutterI18n.translate(context, 'hello'),
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showLanguageDialog(context);
              },
              child: Text(FlutterI18n.translate(context, 'change_language')),
            ),
          ],
        ),
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
