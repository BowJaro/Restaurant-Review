import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:restaurant_review/modules/sign_in/binding/sign_in_binding.dart';
import 'package:restaurant_review/routes/routes.dart';

import 'modules/language/controller/language_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LocaleController localeController = Get.put(LocaleController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Flutter i18n Demo',
        debugShowCheckedModeBanner: false,
        locale: Locale(localeController.locale.value),
        fallbackLocale: const Locale('en'),
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              fallbackFile: 'en',
              decodeStrategies: [JsonDecodeStrategy()],
            ),
            missingTranslationHandler: (key, locale) {
              debugPrint(
                  "--- Missing Key: $key, languageCode: ${locale?.languageCode}");
            },
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('vi'),
        ],
        initialBinding: SignInBinding(),
        initialRoute: Routes.signIn,
        getPages: AppPages.routes,
      );
    });
  }
}
