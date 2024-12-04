import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';

import '../repository/feedback_repository.dart';

class FeedbackController extends GetxController {
  final FeedbackRepository repository;
  FeedbackController(this.repository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  /// Insert a feedback into the database
  Future<void> insertFeedback() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "error.please_fill_all_required_fields"));
      return;
    }
    await repository.insertFeedback(
        title: titleController.text.trim(),
        description: descriptionController.text.trim());
    Get.back();
    ModalUtils.showMessageModal(
        FlutterI18n.translate(Get.context!, "snackbar.success"));
  }
}
