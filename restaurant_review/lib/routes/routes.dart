import 'package:get/get.dart';
import 'package:restaurant_review/modules/sign_in/binding/sign_in_binding.dart';
import 'package:restaurant_review/modules/sign_in/view/sign_in_view.dart';

abstract class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String language = '/language';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
}

class AppPages {
  static const initial = Routes.signIn;
  static final routes = [
    GetPage(
      name: Routes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
  ];
}
