import 'package:get/get.dart';
import 'package:restaurant_review/modules/brand_detail/binding/brand_detail_binding.dart';
import 'package:restaurant_review/modules/brand_detail/view/brand_detail_view.dart';
import 'package:restaurant_review/modules/home/binding/home_binding.dart';
import 'package:restaurant_review/modules/home/view/home_view.dart';
import 'package:restaurant_review/modules/post_detail/binding/post_detail_binding.dart';
import 'package:restaurant_review/modules/post_detail/view/post_detail_view.dart';
import 'package:restaurant_review/modules/restaurant_detail/binding/restaurant_detail_binding.dart';
import 'package:restaurant_review/modules/restaurant_detail/view/restaurant_detail_view.dart';
import 'package:restaurant_review/modules/sign_in/binding/sign_in_binding.dart';
import 'package:restaurant_review/modules/sign_in/view/sign_in_view.dart';
import 'package:restaurant_review/modules/sign_up/binding/sign_up_binding.dart';
import 'package:restaurant_review/modules/sign_up/view/sign_up_view.dart';
import 'package:restaurant_review/modules/splash/binding/splash_binding.dart';
import 'package:restaurant_review/modules/splash/view/splash_view.dart';

import '../modules/account/binding/account_binding.dart';
import '../modules/account/view/account_view.dart';

abstract class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String language = '/language';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String postDetail = '/post_detail';
  static const String brandDetail = '/brand_detail';
  static const String restaurantDetail = '/restaurant_detail';
  static const String account = '/account';
}

class AppPages {
  static const initial = Routes.signIn;
  static final routes = [
    GetPage(
      name: Routes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.postDetail,
      page: () => const PostDetailView(),
      binding: PostDetailBinding(),
    ),
    GetPage(
      name: Routes.brandDetail,
      page: () => const BrandDetailView(),
      binding: BrandDetailBinding(),
    ),
    GetPage(
      name: Routes.restaurantDetail,
      page: () => const RestaurantDetailView(),
      binding: RestaurantDetailBinding(),
    ),
    GetPage(
      name: Routes.account,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
  ];
}
