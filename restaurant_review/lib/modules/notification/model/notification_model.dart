import 'package:get/get.dart';

class NotificationModel {
  final int id;
  final String name;
  final String description;
  final String source;
  final String? type;
  final DateTime createdAt;
  final RxBool isRead;
  final String? imageUrl;

  NotificationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.source,
    required this.type,
    required this.createdAt,
    required this.isRead,
    required this.imageUrl,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      source: map['source'],
      type: map['type'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      isRead: map['is_read'] == true ? true.obs : false.obs,
      imageUrl: map['image_url'],
    );
  }
}
