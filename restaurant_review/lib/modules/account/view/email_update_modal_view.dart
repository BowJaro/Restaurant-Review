import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';

import '../controller/account_controller.dart';

class EmailUpdateModalView extends GetView<AccountController> {
  const EmailUpdateModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, "account_page.update_email")),
      content: MyInputField(
        label: FlutterI18n.translate(context, "account_page.email"),
        textController: controller.emailController,
        validator: controller.validateEmail,
      ),
      actions: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align buttons to the right
          children: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog without saving
              },
              child:
                  Text(FlutterI18n.translate(context, "account_page.cancel")),
            ),
            SizedBox(width: 10), // Add space between buttons
            TextButton(
              onPressed: () {
                controller.updateEmail();
                Get.back(); // Close the dialog after saving
              },
              child: Text(FlutterI18n.translate(context, "account_page.save")),
            ),
          ],
        ),
      ],
    );
  }
}
