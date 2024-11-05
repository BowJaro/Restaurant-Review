import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_review/constants/colors.dart';

class HashtagSelectorController extends GetxController {
  final hashtags = <String>[].obs;
  final TextEditingController newHashtagController = TextEditingController();

  HashtagSelectorController({List<String>? initialHashtags}) {
    if (initialHashtags != null) {
      hashtags.addAll(initialHashtags);
    }
  }

  void addHashtag(String hashtag) {
    if (hashtag.isNotEmpty && !hashtags.contains(hashtag)) {
      hashtags.add(hashtag);
      newHashtagController.clear();
    }
  }

  void showHashtagModal() {
    Get.bottomSheet(
      Container(
        color: AppColors.white,
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newHashtagController,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(
                          Get.context!, "post_detail.enter_new_hash_tags"),
                      prefixText: '#',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    addHashtag(newHashtagController.text.trim());
                    Get.back();
                  },
                  child: Text(
                      FlutterI18n.translate(Get.context!, "post_detail.add")),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                spacing: 8,
                children: hashtags
                    .map((tag) => Chip(
                          label: Text('#$tag'),
                          onDeleted: () => hashtags.remove(tag),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class HashtagSelector extends StatelessWidget {
  final HashtagSelectorController controller;

  const HashtagSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            controller.showHashtagModal();
          },
          child: Text(FlutterI18n.translate(context, "post_detail.hashtags")),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.hashtags
                    .map(
                      (hashtag) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text('#$hashtag'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
