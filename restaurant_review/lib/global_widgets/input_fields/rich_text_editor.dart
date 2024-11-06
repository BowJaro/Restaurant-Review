import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:restaurant_review/constants/font_sizes.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';

class MyRichTextEditorController extends GetxController {
  final quillController = quill.QuillController.basic();
  final focusNode = FocusNode();

  String getQuillContentAsJson() {
    return jsonEncode(quillController.document.toDelta().toJson());
  }

  @override
  void onClose() {
    quillController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}

class MyRichTextEditor extends StatelessWidget {
  final String? initialContent;

  const MyRichTextEditor({super.key, this.initialContent});

  @override
  Widget build(BuildContext context) {
    final MyRichTextEditorController controller =
        Get.put(MyRichTextEditorController());

    if (initialContent != null) {
      var value = jsonDecode(initialContent!);
      controller.quillController.document = quill.Document.fromJson(value);
    }

    // Request focus on the text editor when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.focusNode.requestFocus();
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ModalUtils.showMessageWithButtonsModal(
              FlutterI18n.translate(context, "rich_text_editor.discard_title"),
              FlutterI18n.translate(
                  context, "rich_text_editor.discard_content"),
              () {
                Get.back();
                Get.back(result: null);
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              String content = controller.getQuillContentAsJson();
              Get.back(result: content);
            },
            child: Text(
              FlutterI18n.translate(context, "rich_text_editor.save"),
              style: const TextStyle(
                fontSize: AppFontSizes.s7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: quill.QuillEditor(
                controller: controller.quillController,
                scrollController: ScrollController(),
                focusNode: controller.focusNode,
              ),
            ),
            quill.QuillToolbar.simple(controller: controller.quillController),
          ],
        ),
      ),
    );
  }
}
