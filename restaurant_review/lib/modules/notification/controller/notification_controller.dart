import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/modules/notification/model/notification_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../repository/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository repository;
  NotificationController(this.repository);

  RxBool isLoading = true.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    if (userId == null) {
      Get.offAllNamed(Routes.splash);
      return;
    }
    await getNotifications();
    isLoading.value = false;
  }

  Future<void> getNotifications() async {
    var response = await repository.getNotification(userId!);
    if (response != null) {
      notificationList.value = (response as List<dynamic>)
          .map((item) => NotificationModel.fromMap(item))
          .toList();
    }
  }

  String convertDateTimeToString(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  void goToDetail(int index) {
    markRead(index);

    switch (notificationList[index].type) {
      case "post":
        Get.toNamed(Routes.postPage,
            arguments: {"postId": int.parse(notificationList[index].source)});
        break;
    }
  }

  void markRead(int index) {
    notificationList[index].isRead.value = true;
    repository.toggleIsRead(notificationList[index].id, true);
  }

  void markUnread(int index) {
    notificationList[index].isRead.value = false;
    repository.toggleIsRead(notificationList[index].id, false);
  }

  void removeNotification(int index) {
    repository.removeNotification(notificationList[index].id);
    notificationList.removeAt(index);
    Get.back();
  }
}
