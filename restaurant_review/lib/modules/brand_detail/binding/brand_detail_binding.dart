import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/brand_detail_controller.dart';
import '../provider/brand_detail_provider.dart';
import '../repository/brand_detail_repository.dart';

class BrandDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrandDetailProvider>(() => BrandDetailProvider(supabase));
    Get.lazyPut<BrandDetailRepository>(
        () => BrandDetailRepository(Get.find<BrandDetailProvider>()));
    Get.lazyPut<BrandDetailController>(
        () => BrandDetailController(Get.find<BrandDetailRepository>()));
  }
}
