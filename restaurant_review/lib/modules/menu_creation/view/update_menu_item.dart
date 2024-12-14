import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';

import '../controller/menu_creation_controller.dart';

class UpdateMenuItem extends GetView<MenuCreationController> {
  final int index;
  const UpdateMenuItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailPageAppBar(
        title: FlutterI18n.translate(context, "menu_creation.update_menu"),
        buttonLabel: FlutterI18n.translate(context, "menu_creation.save"),
        onPressed: () {
          controller.updateMenu(index);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            MyInputField(
              label: FlutterI18n.translate(context, "menu_creation.name"),
              textController: controller.nameController,
            ),
            const SizedBox(height: 10.0),
            MyInputField(
              label:
                  FlutterI18n.translate(context, "menu_creation.description"),
              textController: controller.descriptionController,
            ),
            const SizedBox(height: 10.0),
            MyInputField(
              label: FlutterI18n.translate(context, "menu_creation.price"),
              textController: controller.priceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            AvatarSelectorWidget(
              controller: controller.avatarSelectorController,
              size: 150,
            ),
          ],
        ),
      ),
    );
  }
}
