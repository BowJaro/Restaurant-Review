import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/rate.dart';
import 'package:restaurant_review/global_widgets/hashtag/hashtag_selector.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_selector.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/post_detail/model/get_data_for_post_model.dart';
import 'package:restaurant_review/modules/post_detail/model/post_upsert_model.dart';
import 'package:restaurant_review/modules/post_detail/model/post_with_rate_upsert_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/data_for_new_post_model.dart';
import '../repository/post_detail_repository.dart';

class PostDetailController extends GetxController {
  var isLoading = true.obs;
  late bool isNew;
  int? id;
  var hasRateSection = false.obs;
  var hasRestaurantSection = false.obs;

  final TextEditingController nameController = TextEditingController();
  final ImageSelectorController imageSelectorController =
      Get.put(ImageSelectorController());
  final HashtagSelectorController hashtagSelectorController =
      Get.put(HashtagSelectorController());
  late final String? userId;

  var description =
      "[{\"insert\":\"${FlutterI18n.translate(Get.context!, "post_detail.description")}\\n\"}]"
          .obs;

  var topicId = 0.obs;
  var restaurantId = 0.obs;
  var metadataId = 0.obs;
  var rateList = <RateModel>[].obs;
  var rateId = 0.obs;

  late final List<Map<String, String>> topicSuggestionList;
  late final List<Map<String, String>> restaurantSuggestionList;

  final PostDetailRepository repository;
  PostDetailController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    final arguments = Get.arguments;
    isNew = arguments['isNew'] ?? true;
    id = arguments['id'];
    userId = await getSessionId();

    if (!isNew && id != null) {
      await fetchDataForPostEdit();
    } else {
      await fetchDataForNewPost();
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    imageSelectorController.dispose();
    hashtagSelectorController.dispose();
    super.onClose();
  }

  List<Map<String, String>> toMapList(List<dynamic> mapList) {
    return mapList
        .map((item) => {
              "value": item.id.toString(),
              "name": item.name.toString(),
            })
        .toList();
  }

  bool validateFields() {
    if (nameController.text.isEmpty ||
        topicId.value == 0 ||
        (restaurantId.value == 0 && hasRateSection.value)) {
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "error.please_fill_all_required_fields"));
      return false;
    }
    return true;
  }

  Future<void> fetchDataForNewPost() async {
    final response = await repository.fetchDataForNewPost();

    if (response != null) {
      final dataForNewPostModel = DataForNewPostModel.fromMap(response);
      topicSuggestionList = toMapList(dataForNewPostModel.topicList);
      restaurantSuggestionList = toMapList(dataForNewPostModel.restaurantList);
      rateList.value = dataForNewPostModel.rateList;
      assignRateList();
    }
  }

  Future<void> fetchDataForPostEdit() async {
    final response = await repository.fetchDataForPostEdit(id!);

    if (response != null) {
      final dataForPostEdit = GetDataForPostModel.fromMap(response);
      id = dataForPostEdit.id;
      topicSuggestionList = toMapList(dataForPostEdit.topicList);
      restaurantSuggestionList = toMapList(dataForPostEdit.restaurantList);
      rateList.value = dataForPostEdit.rateList;
      rateId.value = dataForPostEdit.rateId;
      metadataId.value = dataForPostEdit.metadataId;
      nameController.text = dataForPostEdit.name;
      description.value = dataForPostEdit.content;
      topicId.value = dataForPostEdit.topicId;
      restaurantId.value = dataForPostEdit.restaurantId;
      hashtagSelectorController.setHashtags(dataForPostEdit.hashtagList);
      imageSelectorController.setImageList(dataForPostEdit.imageUrlList);
      assignRateList();
    }
  }

  void assignRateList() {
    for (var rate in rateList) {
      final oldName = rate.name.toLowerCase();
      final newName =
          FlutterI18n.translate(Get.context!, "post_detail.$oldName");
      rate.name = newName;
    }
  }

  void upsertPost() async {
    if (validateFields()) {
      if (userId == null) {
        ModalUtils.showMessageWithButtonsModal(
          FlutterI18n.translate(Get.context!, "error.error"),
          FlutterI18n.translate(Get.context!, "error.please_sign_in_first"),
          () => Get.offAllNamed(Routes.splash),
        );
        return;
      } else {
        ModalUtils.showLoadingIndicator();

        if (hasRateSection.value) {
          PostWithRateUpsertModel postWithRateUpsertModel =
              PostWithRateUpsertModel(
            id: id,
            topicId: topicId.value,
            name: nameController.text.trim(),
            metadataId: metadataId.value == 0 ? null : metadataId.value,
            content: description.value,
            hashtagList: hashtagSelectorController.hashtags,
            imageList: imageSelectorController.imageItems
                .map((item) => item.file ?? item.url)
                .toList(),
            profileId: userId!,
            restaurantId: restaurantId.value,
            rateList: rateList,
            rateId: rateId.value == 0 ? null : rateId.value,
          );
          await repository.upsertPostWithRate(postWithRateUpsertModel);
        } else {
          PostUpsertModel postUpsertModel = PostUpsertModel(
            id: id,
            topicId: topicId.value,
            name: nameController.text.trim(),
            metadataId: metadataId.value == 0 ? null : metadataId.value,
            content: description.value,
            hashtagList: hashtagSelectorController.hashtags,
            imageList: imageSelectorController.imageItems
                .map((item) => item.file ?? item.url)
                .toList(),
            profileId: userId!,
            restaurantId: restaurantId.value == 0 ? null : restaurantId.value,
          );
          await repository.upsertPost(postUpsertModel);
        }

        Get.back();
      }
    }
  }

  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }
}
