import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_widgets/cards/restaurant_card.dart';
import '../controller/brand_page_controller.dart';

class BrandPageView extends GetView<BrandPageController> {
  const BrandPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterI18n.translate(context, "brand_page.brand")),
            centerTitle: true,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.brandPageModel.name),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      baseImageUrl + controller.brandPageModel.imageUrl),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  controller.brandPageModel.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AbsorbPointer(
                child: quill.QuillEditor.basic(
                  controller: quill.QuillController(
                    document: quill.Document.fromJson(
                      jsonDecode(controller.brandPageModel.description),
                    ),
                    selection: const TextSelection.collapsed(offset: 0),
                  ),
                ),
              ),
              controller.brandPageModel.restaurantList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          FlutterI18n.translate(
                              context, "brand_page.restaurant_list"),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.brandPageModel.restaurantList.length,
                itemBuilder: (context, index) {
                  final item = controller.brandPageModel.restaurantList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Obx(() {
                      return RestaurantCard(
                        restaurantId: item.id,
                        imageUrl: item.imageUrl,
                        name: item.name,
                        hashtagList: item.hashtagList,
                        rateAverage: item.rateAverage,
                        isFollowed: item.isFollowed.value,
                        street: item.street,
                        provinceId: item.provinceId,
                        districtId: item.districtId,
                        wardId: item.wardId,
                        onHeartTap: () {
                          controller.onHeartTap(item);
                        },
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}
