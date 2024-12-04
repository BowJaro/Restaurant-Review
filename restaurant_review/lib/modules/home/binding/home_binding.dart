import 'package:get/get.dart';
import 'package:restaurant_review/modules/account/binding/account_binding.dart';
import 'package:restaurant_review/modules/explore/binding/explore_binding.dart';
import 'package:restaurant_review/modules/feed/binding/feed_binding.dart';
import 'package:restaurant_review/modules/home/controller/home_controller.dart';
import 'package:restaurant_review/modules/saved/binding/saved_binding.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    AccountBinding().dependencies();
    FeedBinding().dependencies();
    SavedBinding().dependencies();
    ExploreBinding().dependencies();
  }
}
