import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';

import '../controller/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailPageAppBar(
        title: FlutterI18n.translate(context, "report.report"),
        buttonLabel: FlutterI18n.translate(context, "report.send"),
        onPressed: () => controller.submitReport(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title input
              MyInputField(
                label: FlutterI18n.translate(context, "report.reason"),
                textController: controller.titleController,
              ),
              const SizedBox(height: 16),
              // Description input
              MyInputField(
                label: FlutterI18n.translate(context, "report.description"),
                textController: controller.descriptionController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
