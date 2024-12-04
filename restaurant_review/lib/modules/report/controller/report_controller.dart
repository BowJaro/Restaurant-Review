import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';

import '../repository/report_repository.dart';

class ReportController extends GetxController {
  final ReportRepository repository;
  ReportController(this.repository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  late String source;
  late String type;

  @override
  void onInit() {
    final Map<String, dynamic> arguments = Get.arguments;
    source = arguments["source"] ?? "";
    type = arguments["type"] ?? "";
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  /// Insert a report into the database
  Future<void> insertReport(
      {required String source,
      required String type,
      required String title,
      required String description}) async {
    await repository.insertReport(
        source: source, type: type, title: title, description: description);
  }

  void submitReport() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "error.please_fill_all_required_fields"));
    } else {
      await insertReport(
          source: source,
          type: type,
          title: titleController.text.trim(),
          description: descriptionController.text.trim());
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "snackbar.success"));
    }
  }
}
