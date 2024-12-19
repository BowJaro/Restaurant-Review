import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/hashtag/hashtag_selector.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/autocomplete_field.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';
import 'package:restaurant_review/global_widgets/input_fields/rich_text_display.dart';
import 'package:restaurant_review/global_widgets/locations/address_selector.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/utils/validators.dart';

import '../controller/restaurant_detail_controller.dart';

class RestaurantDetailView extends GetView<RestaurantDetailController> {
  const RestaurantDetailView({super.key});

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
              ? FlutterI18n.translate(
                  context, "restaurant_detail.create_restaurant")
              : FlutterI18n.translate(
                  context, "restaurant_detail.edit_restaurant"),
          buttonLabel: FlutterI18n.translate(context, "restaurant_detail.save"),
          onPressed: () {
            controller.uploadRestaurant();
          },
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Column(
            children: [
              MyInputField(
                label: FlutterI18n.translate(context, "restaurant_detail.name"),
                textController: controller.nameController,
              ),
              const SizedBox(height: 10.0),
              MyAutocompleteField(
                label: FlutterI18n.translate(
                    context, "restaurant_detail.category"),
                suggestions: controller.categorySuggestionList,
                onSelected: (value) {
                  if (value == null) return;
                  controller.restaurantCategoryId.value =
                      int.tryParse(value) ?? 0;
                },
                defaultValue: controller.defaultCategoryId,
              ),
              const SizedBox(height: 10.0),
              MyAutocompleteField(
                label:
                    FlutterI18n.translate(context, "restaurant_detail.brand"),
                suggestions: controller.brandSuggestionList,
                onSelected: (value) {
                  if (value == null) return;
                  controller.brandId.value = int.tryParse(value) ?? 0;
                },
                defaultValue: controller.defaultBrandId,
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
              HashtagSelector(controller: controller.hashtagController),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: controller.openGoogleMaps,
                      child: Text(
                          FlutterI18n.translate(context, "location.location")),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: controller.locationController,
                      decoration: InputDecoration(
                        labelText: FlutterI18n.translate(
                            context, "location.missing_location"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      validator: ValidatorUtils.validateCoordinates,
                    ),
                  ),
                ],
              ),
              controller.id != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.menuCreation,
                              arguments: {"restaurantId": controller.id});
                        },
                        child: Text(FlutterI18n.translate(
                            context, "restaurant_detail.add_menu")),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10.0),
              AddressSelectorView(
                  controller: controller.addressSelectorController),
              const SizedBox(height: 10.0),
              MyInputField(
                label: FlutterI18n.translate(context, "location.street"),
                textController: controller.streetController,
              ),
              const SizedBox(height: 10.0),
              ImageSelectorWidget(
                  controller: controller.imageSelectorController),
              const SizedBox(height: 10.0),
              AvatarSelectorWidget(
                controller: controller.avatarSelectorController,
                size: 150,
              ),
            ],
          ),
        ),
      );
    });
  }
}
