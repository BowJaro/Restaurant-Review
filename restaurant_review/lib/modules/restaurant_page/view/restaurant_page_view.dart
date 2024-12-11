import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/address.dart';
import 'package:restaurant_review/global_widgets/cards/mini_post_card.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_gallery.dart';
import 'package:restaurant_review/global_widgets/ratings/star_rate.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/utils/address_lookup.dart';

import '../controller/restaurant_page_controller.dart';

class RestaurantPageView extends GetView<RestaurantPageController> {
  const RestaurantPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text(FlutterI18n.translate(context, "restaurant_page.title")),
            centerTitle: true,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.restaurantModel.name),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(
                          baseImageUrl + controller.restaurantModel.imageUrl),
                    ),
                    Obx(() {
                      return GestureDetector(
                        onTap: () {
                          controller.toggleFollowing();
                        },
                        child:
                            controller.restaurantModel.isFollowed.value == true
                                ? const Icon(
                                    Icons.favorite,
                                    color: AppColors.primary,
                                    size: 25,
                                  )
                                : const Icon(Icons.favorite_border, size: 25),
                      );
                    }),
                  ],
                ),
              ),
              Center(
                child: Text(
                  controller.restaurantModel.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    FlutterI18n.translate(context, "restaurant_page.brand"),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5.0),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.brandPage, arguments: {
                        "brandId": controller.restaurantModel.brandId
                      });
                    },
                    child: Text(
                      controller.restaurantModel.brandName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Text(
                "${FlutterI18n.translate(context, "restaurant_page.category")}: ${controller.restaurantModel.restaurantCategoryName}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150.0,
                    child: StarRating(
                        value: controller.restaurantModel.averageRate),
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "${controller.restaurantModel.averageRate}/5",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () => controller.goToGoogleMap(),
                child: Text(
                    FlutterI18n.translate(context, "restaurant_page.location")),
              ),
              FutureBuilder<Address?>(
                future: getAddressName(
                    controller.restaurantModel.provinceId,
                    controller.restaurantModel.districtId,
                    controller.restaurantModel.wardId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "${FlutterI18n.translate(context, "restaurant_page.address")}: ${snapshot.data!}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              Wrap(
                children: controller.restaurantModel.hashtagList
                    .map((hashtag) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '#$hashtag',
                            style: const TextStyle(
                              color: AppColors.textGray,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 15),
              ImageGallery(urls: controller.restaurantModel.imageList),
              const SizedBox(height: 15),
              AbsorbPointer(
                child: quill.QuillEditor.basic(
                  controller: quill.QuillController(
                    document: quill.Document.fromJson(
                      jsonDecode(controller.restaurantModel.description),
                    ),
                    selection: const TextSelection.collapsed(offset: 0),
                  ),
                ),
              ),
              controller.postList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          FlutterI18n.translate(
                              context, "restaurant_page.post_list"),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 15),
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.postList.length,
                  itemBuilder: (context, index) {
                    final item = controller.postList[index].value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MiniPostCard(
                        id: item.id,
                        name: item.name,
                        topic: item.topic,
                        subtitle:
                            item.createdAt.toIso8601String().split('T')[0],
                        imageUrl: item.imageUrl,
                        viewCount: item.viewCount,
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}
