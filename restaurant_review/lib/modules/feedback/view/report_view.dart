import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';

import '../controller/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailPageAppBar(
        title: FlutterI18n.translate(context, "feedback.feedback"),
        buttonLabel: FlutterI18n.translate(context, "feedback.send"),
        onPressed: () => controller.insertFeedback(),
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
                label: FlutterI18n.translate(context, "feedback.reason"),
                textController: controller.titleController,
              ),
              const SizedBox(height: 16),
              // Description input
              MyInputField(
                label: FlutterI18n.translate(context, "feedback.description"),
                textController: controller.descriptionController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
