import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/font_sizes.dart';
import 'package:restaurant_review/global_classes/rate.dart';
import 'package:restaurant_review/global_widgets/appbar/detail_page_app_bar.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_selector.dart';
import 'package:restaurant_review/global_widgets/input_fields/autocomplete_field.dart';
import 'package:restaurant_review/global_widgets/input_fields/input_field.dart';
import 'package:restaurant_review/global_widgets/input_fields/rich_text_display.dart';
import 'package:restaurant_review/global_widgets/ratings/star_rate.dart';
import 'package:restaurant_review/modules/post_detail/controller/post_detail_controller.dart';

import '../../../global_widgets/hashtag/hashtag_selector.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: DetailPageAppBar(
            title: controller.isNew
                ? FlutterI18n.translate(context, "post_detail.create_post")
                : FlutterI18n.translate(context, "post_detail.edit_post"),
            buttonLabel: FlutterI18n.translate(context, "post_detail.post"),
            onPressed: () {
              controller.upsertPost();
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  MyInputField(
                    label: FlutterI18n.translate(context, "post_detail.name"),
                    textController: controller.nameController,
                  ),
                  const SizedBox(height: 10.0),
                  MyAutocompleteField(
                    label: FlutterI18n.translate(context, "post_detail.topic"),
                    suggestions: controller.topicSuggestionList,
                    onSelected: (value) {
                      if (value != null) {
                        controller.topicId.value = int.tryParse(value) ?? 0;
                      }
                    },
                    defaultValue: controller.topicId.value.toString(),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 120.0,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.hasRestaurantSection.value =
                            !controller.hasRestaurantSection.value;
                      },
                      child: Text(FlutterI18n.translate(
                          context, "post_detail.restaurant")),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Obx(() {
                    if (controller.hasRestaurantSection.value) {
                      return MyAutocompleteField(
                        label: FlutterI18n.translate(
                            context, "post_detail.restaurant"),
                        suggestions: controller.restaurantSuggestionList,
                        onSelected: (value) {
                          if (value != null) {
                            controller.restaurantId.value =
                                int.tryParse(value) ?? 0;
                          }
                        },
                        defaultValue: controller.restaurantId.value.toString(),
                      );
                    }
                    return const SizedBox();
                  }),
                  const SizedBox(height: 10),
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
                  HashtagSelector(
                      controller: controller.hashtagSelectorController),
                  const SizedBox(height: 10.0),
                  ImageSelectorWidget(
                      controller: controller.imageSelectorController,
                      size: 100),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 120.0,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.hasRateSection.value =
                            !controller.hasRateSection.value;
                      },
                      child: Text(
                          FlutterI18n.translate(context, "post_detail.rate")),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Obx(() {
                    if (controller.hasRateSection.value) {
                      return getRatingSection();
                    }
                    return const SizedBox();
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getRatingSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: controller.rateList.length,
      itemBuilder: (context, index) {
        return getRowRating(rate: controller.rateList[index]);
      },
    );
  }

  Widget getRowRating({required RateModel rate, double size = 23}) {
    double width = Get.size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: width * 0.3,
          child: Text(
            rate.name,
            style: const TextStyle(fontSize: AppFontSizes.s7),
          ),
        ),
        SizedBox(
          width: width * 0.5,
          child: Obx(() {
            return StarRating(
              value: rate.value.value,
              size: size,
              onPressed: (value) {
                rate.value.value = value + 0.0;
              },
            );
          }),
        ),
      ],
    );
  }
}
