import 'package:get/get.dart';

class RateModel {
  final int? id; // rate_content.id
  final int rateTypeId;
  String name;
  final RxDouble value;

  RateModel({
    required this.id,
    required this.rateTypeId,
    required this.name,
    required this.value,
  });

  factory RateModel.fromMap(Map<String, dynamic> map) {
    return RateModel(
      id: map['id'],
      rateTypeId: map['rate_type_id'],
      name: map['name'],
      value: RxDouble(map['value'] == null ? 5.0 : map['value'] + 0.0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rate_type_id': rateTypeId,
      'name': name,
      'value': value.value.toInt(),
    };
  }
}
