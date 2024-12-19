import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/search/controller/search_page_controller.dart';
import 'package:restaurant_review/modules/search/provider/search_provider.dart';
import 'package:restaurant_review/modules/search/repository/search_repository.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchProvider>(() => SearchProvider(supabase));
    Get.lazyPut<SearchRepository>(
        () => SearchRepository(Get.find<SearchProvider>()));
    Get.lazyPut<SearchPageController>(
        () => SearchPageController(Get.find<SearchRepository>()));
  }
}
