import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LocaleController extends GetxController {
  static const String _storageKey = 'selected_language';
  var locale = 'en'.obs; // Change to string

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  void _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_storageKey);
    if (languageCode != null) {
      locale.value = languageCode;
      Get.updateLocale(Locale(languageCode));
    }
  }

  void changeLocale(String languageCode) async {
    locale.value = languageCode;
    Get.updateLocale(Locale(languageCode));
    FlutterI18n.refresh(
        Get.context!, Locale(languageCode)); // Refresh the translations
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, languageCode);
  }
}
