import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.white, // Set back icon color to white
        ),
        title: Text(
          FlutterI18n.translate(context, "notification.notification"),
          style: const TextStyle(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Container(
          color: AppColors.pageBgGray,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.notificationList.length,
            itemBuilder: (context, index) {
              final contentPart =
                  controller.notificationList[index].description.split(":::");
              return Obx(() {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: AppColors.errorRed,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.delete,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) {
                    return Get.defaultDialog(
                      title: FlutterI18n.translate(
                          context, "notification.remove_notification"),
                      middleText: FlutterI18n.translate(
                          context, "notification.confirm_remove_notification"),
                      textConfirm: FlutterI18n.translate(context, "modal.yes"),
                      textCancel:
                          FlutterI18n.translate(context, "modal.cancel"),
                      onConfirm: () {
                        controller.removeNotification(index);
                      },
                    );
                  },
                  key: Key(controller.notificationList[index].id.toString()),
                  child: Container(
                    color: controller.notificationList[index].isRead.value
                        ? AppColors.white
                        : AppColors.backgroundGray,
                    margin: const EdgeInsets.only(bottom: 2.0),
                    child: ListTile(
                      onTap: () => controller.goToDetail(index),
                      leading: controller.notificationList[index].imageUrl ==
                              null
                          ? const CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.notifications),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(baseImageUrl +
                                  controller.notificationList[index].imageUrl!),
                            ),
                      title: Text(
                        FlutterI18n.translate(context,
                            "notification.${controller.notificationList[index].name}"),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${contentPart[0]} ${FlutterI18n.translate(context, "notification.${contentPart[1]}")}"),
                          const SizedBox(height: 5.0),
                          Text(
                            controller.convertDateTimeToString(
                                controller.notificationList[index].createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          controller.markUnread(index);
                        },
                        icon: const Icon(Icons.mark_unread_chat_alt),
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }
}
