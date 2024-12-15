import '../provider/notification_provider.dart';

class NotificationRepository {
  final NotificationProvider provider;

  NotificationRepository(this.provider);

  Future<dynamic> getNotification(String userId) async {
    return await provider.fetchNotificationsByProfileId(userId);
  }

  Future<void> removeNotification(int notificationId) async {
    return await provider.removeNotification(notificationId);
  }

  Future<void> toggleIsRead(int notificationId, bool isRead) async {
    return await provider.toggleIsRead(notificationId, isRead);
  }
}
