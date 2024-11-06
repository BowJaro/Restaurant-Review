import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/modules/splash/binding/splash_binding.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/services/global_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'modules/language/controller/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://edspkihukjhdlbyydnks.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVkc3BraWh1a2poZGxieXlkbmtzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAwODYyNzQsImV4cCI6MjA0NTY2MjI3NH0.yXlg9FzcgebLD5s5SExQ3uMQ4VAqPZBVkryo_0qcruM',
  );
  GlobalBinding().dependencies();
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
        initialBinding: SplashBinding(),
        initialRoute: Routes.splash,
        getPages: AppPages.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
        ),
      );
    });
  }
}
