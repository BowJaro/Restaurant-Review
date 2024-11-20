import 'package:get/get.dart';
import 'package:restaurant_review/modules/account/binding/account_binding.dart';
import 'package:restaurant_review/modules/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    AccountBinding().dependencies();
  }
}
