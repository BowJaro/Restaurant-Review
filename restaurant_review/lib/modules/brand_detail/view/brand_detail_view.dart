import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';
import 'package:restaurant_review/global_widgets/input_fields/rich_text_display.dart';

import '../controller/brand_detail_controller.dart';

class BrandDetailView extends GetView<BrandDetailController> {
  const BrandDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: DetailPageAppBar(
          title: controller.isNew
              ? FlutterI18n.translate(context, "brand_detail.create_brand")
              : FlutterI18n.translate(context, "brand_detail.edit_brand"),
          buttonLabel: FlutterI18n.translate(context, "brand_detail.add"),
          onPressed: () => controller.upsertBrand(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Column(
              children: [
                MyInputField(
                  label: FlutterI18n.translate(context, "brand_detail.name"),
                  textController: controller.nameController,
                ),
                const SizedBox(height: 10.0),
                Obx(
                  () => RichTextDisplay(
                    content: controller.description.value,
                    onContentChanged: (newContent) {
                      if (newContent != null) {
                        controller.description.value = newContent;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                AvatarSelectorWidget(
                  controller: controller.avatarSelectorController,
                  size: 150,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
