import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';

import '../controller/menu_creation_controller.dart';

class MenuCreationView extends GetView<MenuCreationController> {
  const MenuCreationView({super.key});

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
          title: FlutterI18n.translate(context, "menu_creation.menu_item"),
          buttonLabel: FlutterI18n.translate(context, "menu_creation.save"),
          onPressed: () => controller.createMenuItem(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: [
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
                icon: Icons.fastfood,
              ),
              ElevatedButton(
                onPressed: () {
                  controller.addMenuToList();
                },
                child:
                    Text(FlutterI18n.translate(context, "menu_creation.add")),
              ),
              const SizedBox(height: 10.0),
              Obx(
                () => ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.menuList.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return ListTile(
                        onTap: () => controller.goToUpdateMenu(index),
                        leading: controller.menuList[index].image.value.url
                                is String
                            ? Image.network(
                                baseImageUrl +
                                    controller.menuList[index].image.value.url!,
                                width: 50,
                                height: 50,
                              )
                            : Image.file(
                                File((controller.menuList[index].image.value
                                        .file as XFile)
                                    .path),
                                width: 50,
                                height: 50,
                              ),
                        title: Text(controller.menuList[index].name.value),
                        subtitle:
                            Text(controller.menuList[index].price.toString()),
                        trailing: IconButton(
                          onPressed: () {
                            controller.removeMenu(index);
                          },
                          icon: const Icon(Icons.remove_circle_outlined),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
