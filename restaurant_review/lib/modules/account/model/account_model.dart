import 'package:restaurant_review/global_classes/image_item.dart';

class AccountModel {
  String? id;
  String userName;
  String fullName;
  String email;
  String phone;
  ImageItem image;

  AccountModel({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.image,
  });

  factory AccountModel.fromMap(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      userName: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      image: ImageItem(
        url: json['url'],
      ),
    );
  }
}
