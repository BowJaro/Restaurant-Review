import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:restaurant_review/global_widgets/cards/restaurant_card.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../controller/restaurant_management_controller.dart';

class RestaurantManagementView extends GetView<RestaurantManagementController> {
  const RestaurantManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.white, // Set back icon color to white
        ),
        title: Text(
          FlutterI18n.translate(context, "restaurant_management.title"),
          style: const TextStyle(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.brandModel == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () async {
                await Get.toNamed(Routes.brandDetail,
                    arguments: {"isNew": true, "isOwner": true});
                controller.getData();
              },
              child: Text(FlutterI18n.translate(
                  context, "restaurant_management.add_brand")),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.brandDetail, arguments: {
                    "id": controller.brandModel!.id,
                    "isNew": false
                  });
                  controller.getData();
                },
                child: CircleAvatar(
                  radius: 75.0,
                  backgroundImage: NetworkImage(
                      baseImageUrl + controller.brandModel!.imageUrl),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                controller.brandModel!.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              AbsorbPointer(
                child: quill.QuillEditor.basic(
                  controller: quill.QuillController(
                    document: quill.Document.fromJson(
                      jsonDecode(controller.brandModel!.description),
                    ),
                    selection: const TextSelection.collapsed(offset: 0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  await Get.toNamed(Routes.restaurantDetail,
                      arguments: {"isNew": true});
                  controller.getData();
                },
                child: Text(FlutterI18n.translate(
                    context, "restaurant_management.add_restaurant")),
              ),
              const SizedBox(height: 10.0),
              Obx(() {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16.0),
                  shrinkWrap: true,
                  itemCount: controller.restaurantList.length,
                  itemBuilder: (context, index) {
                    final restaurant = controller.restaurantList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Obx(() {
                        return GestureDetector(
                          onLongPress: () {
                            controller
                                .confirmRemoveRestaurant(restaurant.value.id);
                          },
                          child: RestaurantCardBasic(
                            restaurantId: restaurant.value.id,
                            imageUrl: restaurant.value.imageUrl,
                            name: restaurant.value.name,
                            hashtagList: restaurant.value.hashtagList,
                            rateAverage: restaurant.value.rateAverage,
                            street: restaurant.value.street,
                            provinceId: restaurant.value.provinceId,
                            districtId: restaurant.value.districtId,
                            wardId: restaurant.value.wardId,
                            onTap: () async {
                              await Get.toNamed(Routes.restaurantDetail,
                                  arguments: {
                                    "id": restaurant.value.id,
                                    "isNew": false
                                  });
                              controller.getData();
                            },
                          ),
                        );
                      }),
                    );
                  },
                );
              })
            ],
          ),
        );
      }),
    );
  }
}
