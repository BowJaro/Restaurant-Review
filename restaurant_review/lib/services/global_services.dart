import 'package:get/get.dart';
import 'package:restaurant_review/services/image_service.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageService>(() => ImageService());
    // Add other global services here
  }
}
