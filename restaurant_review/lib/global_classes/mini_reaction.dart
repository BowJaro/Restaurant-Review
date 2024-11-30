import 'package:get/get.dart';

class MiniReactionModel {
  final int id;
  RxString content;

  MiniReactionModel({required this.id, required this.content});

  factory MiniReactionModel.fromMap(Map<String, dynamic> map) {
    return MiniReactionModel(
      id: map['reaction_id'] as int,
      content: (map['content'] as String).obs,
    );
  }
}
