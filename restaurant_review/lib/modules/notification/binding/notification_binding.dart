import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import '../controller/notification_controller.dart';
import '../provider/notification_provider.dart';
import '../repository/notification_repository.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationProvider>(() => NotificationProvider(supabase));
    Get.lazyPut<NotificationRepository>(
        () => NotificationRepository(Get.find<NotificationProvider>()));
    Get.lazyPut<NotificationController>(
        () => NotificationController(Get.find<NotificationRepository>()));
  }
}
