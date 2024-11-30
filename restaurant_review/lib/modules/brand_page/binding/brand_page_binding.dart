import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/brand_page_controller.dart';
import '../provider/brand_page_provider.dart';
import '../repository/brand_page_repository.dart';

class BrandPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrandPageProvider>(() => BrandPageProvider(supabase));
    Get.lazyPut<BrandPageRepository>(
        () => BrandPageRepository(Get.find<BrandPageProvider>()));
    Get.lazyPut<BrandPageController>(
        () => BrandPageController(Get.find<BrandPageRepository>()));
  }
}
