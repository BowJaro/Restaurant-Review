import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/global_widgets/input_fields/rich_text_editor.dart';

class RichTextDisplayController extends GetxController {
  var quillController = quill.QuillController.basic().obs;

  void setContent(String content) {
    var value = jsonDecode(content);
    quillController.value.document = quill.Document.fromJson(value);
  }
}

class RichTextDisplay extends StatelessWidget {
  final String content;
  final ValueChanged<String?> onContentChanged;

  const RichTextDisplay({
    super.key,
    required this.content,
    required this.onContentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final RichTextDisplayController controller =
        Get.put(RichTextDisplayController());

    controller.setContent(content);

    return GestureDetector(
      onTap: () async {
        final result = await Get.to(() => MyRichTextEditor(
              initialContent: content,
            ));

        if (result != null) {
          onContentChanged(result);
          controller.setContent(result);
        }
      },
      child: AbsorbPointer(
        // This makes sure the editor does not gain focus or handle taps
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textBlack, width: 0.7),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Obx(() => quill.QuillEditor.basic(
              controller: controller.quillController.value)),
        ),
      ),
    );
  }
}
