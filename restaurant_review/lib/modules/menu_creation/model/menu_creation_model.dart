import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/image_item.dart';

class MenuCreationModel {
  int? id;
  RxString name;
  RxString description;
  RxDouble price;
  Rx<ImageItem> image;

  MenuCreationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory MenuCreationModel.fromMap(Map<String, dynamic> json) {
    return MenuCreationModel(
      id: json['id'],
      name: RxString(json['name']),
      description: RxString(json['description']),
      price: RxDouble(json['price']),
      image: Rx<ImageItem>(ImageItem(url: json['image_url'])),
    );
  }
}
