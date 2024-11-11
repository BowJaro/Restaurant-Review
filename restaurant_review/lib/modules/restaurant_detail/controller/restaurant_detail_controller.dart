import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/image_item.dart';
import 'package:restaurant_review/global_classes/mini_brand.dart';
import 'package:restaurant_review/global_classes/mini_restaurant_category.dart';
import 'package:restaurant_review/global_widgets/hashtag/hashtag_selector.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';
import 'package:restaurant_review/global_widgets/image_widgets/image_selector.dart';
import 'package:restaurant_review/global_widgets/locations/address_selector.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/restaurant_detail/model/restaurant_get_model.dart';
import 'package:restaurant_review/modules/restaurant_detail/model/restaurant_upsert_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/data_for_new_restaurant_model.dart';
import '../repository/restaurant_detail_repository.dart';

class RestaurantDetailController extends GetxController {
  var isLoading = true.obs;
  late bool isNew;
  int? id;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final HashtagSelectorController hashtagController =
      HashtagSelectorController();
  final ImageSelectorController imageSelectorController =
      Get.put(ImageSelectorController());
  final AddressSelectorController addressSelectorController =
      Get.put(AddressSelectorController());
  final AvatarSelectorController avatarSelectorController =
      Get.put(AvatarSelectorController());
  var description =
      "[{\"insert\":\"${FlutterI18n.translate(Get.context!, "restaurant_detail.description")}\\n\"}]"
          .obs;

  late final DataForNewRestaurantModel dataForNewRestaurantModel;
  late final List<Map<String, String>> brandSuggestionList;
  late final List<Map<String, String>> categorySuggestionList;

  late final String? defaultBrandId;
  late final String? defaultCategoryId;

  // Define required and optional fields as observable variables
  var name = ''.obs; // Required
  var metadataId = 0.obs; // Required
  var restaurantCategoryId = 0.obs; // Required
  var brandId = 0.obs; // Required
  var hashtag = <String>[].obs; // Optional
  var avatarId = 0.obs; // Required
  var addressId = 0.obs; // Required
  var provinceId = ''.obs; // Required
  var districtId = ''.obs; // Required
  var wardId = ''.obs; // Optional
  var street = ''.obs; // Required
  var locationId = 0.obs; // Required
  var location = ''.obs; // Required
  var imageList = <ImageItem>[].obs; // Optional

  final RestaurantDetailRepository repository;
  RestaurantDetailController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    final arguments = Get.arguments;
    isNew = arguments['isNew'] ?? true;
    id = arguments['id'];

    if (!isNew && id != null) {
      await fetchRestaurantDetail();
    } else {
      await fetchDataForNewRestaurant();
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    locationController.dispose();
    hashtagController.dispose();
    addressSelectorController.dispose();
    imageSelectorController.dispose();
    streetController.dispose();
    avatarSelectorController.dispose();
    super.onClose();
  }

  List<Map<String, String>> toBrandMapList(List<MiniBrandModel> brandList) {
    return brandList
        .map((item) => {
              "value": item.id.toString(),
              "name": item.name,
            })
        .toList();
  }

  List<Map<String, String>> toRestaurantCategoryMapList(
      List<MiniRestaurantCategoryModel> restaurantCategoryList) {
    return restaurantCategoryList
        .map((item) => {
              "value": item.id.toString(),
              "name": item.name,
            })
        .toList();
  }

  Future<void> fetchDataForNewRestaurant() async {
    var data = await repository.fetchDataForNewRestaurant();
    Map<String, dynamic> jsonData = data as Map<String, dynamic>;
    dataForNewRestaurantModel = DataForNewRestaurantModel.fromJson(jsonData);
    defaultBrandId = null;
    defaultCategoryId = null;

    brandSuggestionList = toBrandMapList(dataForNewRestaurantModel.brandList);
    categorySuggestionList = toRestaurantCategoryMapList(
        dataForNewRestaurantModel.restaurantCategoryList);
  }

  void openGoogleMaps() async {
    final Uri url = Uri.parse('https://www.google.com/maps');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw '${FlutterI18n.translate(Get.context!, "error.could_not_launch")} $url';
    }
  }

  // Method to validate required fields
  bool validateFields() {
    if (name.isEmpty ||
        restaurantCategoryId == 0 ||
        brandId == 0 ||
        provinceId.isEmpty ||
        districtId.isEmpty ||
        location.isEmpty ||
        street.isEmpty ||
        avatarSelectorController.avatar.value == null) {
      ModalUtils.showMessageModal(FlutterI18n.translate(
          Get.context!, "error.please_fill_all_required_fields"));
      return false;
    }
    return true;
  }

  void prepareData() {
    name.value = nameController.text;
    description.value = description.value;
    imageList.value = imageSelectorController.imageItems;
    street.value = streetController.text;
    location.value = locationController.text;
    hashtag.value = hashtagController.hashtags;
    // restaurantCategoryId.value = restaurantCategoryId.value;
    // brandId.value = brandId.value;
    provinceId.value = addressSelectorController.selectedProvince.value;
    districtId.value = addressSelectorController.selectedDistrict.value;
    wardId.value = addressSelectorController.selectedWard.value;
  }

  // Call this function when the upload button is pressed
  void uploadRestaurant() async {
    prepareData();
    if (validateFields()) {
      ModalUtils.showLoadingIndicator();
      var [latitude, longitude] = location.value.split(',');
      RestaurantUpsertModel restaurantModel = RestaurantUpsertModel(
        id: id,
        name: name.value,
        metadataId: metadataId.value,
        description: description.value,
        imageList: imageList.map((item) => item.file ?? item.url).toList(),
        avatarId: avatarId.value,
        avatar: avatarSelectorController.avatar.value!.file ??
            avatarSelectorController.avatar.value!.url,
        addressId: addressId.value,
        province: provinceId.value,
        district: districtId.value,
        ward: wardId.value,
        street: street.value,
        locationId: locationId.value,
        latitude: double.tryParse(latitude) ?? 0,
        longitude: double.tryParse(longitude) ?? 0,
        hashtagList: hashtag,
        brandId: brandId.value,
        restaurantCategoryId: restaurantCategoryId.value,
      );

      await repository.upsertRestaurant(restaurantModel);
      Get.back();
    }
  }

  Future<void> fetchRestaurantDetail() async {
    var response = await repository.fetchRestaurant(id!);
    RestaurantGetModel restaurantDetailModel =
        RestaurantGetModel.fromMap(response);

    brandId.value = restaurantDetailModel.brandId;
    restaurantCategoryId.value = restaurantDetailModel.restaurantCategoryId;
    metadataId.value = restaurantDetailModel.metadataId;
    addressId.value = restaurantDetailModel.addressId;
    locationId.value = restaurantDetailModel.locationId;
    avatarId.value = restaurantDetailModel.avatarId;

    nameController.text = restaurantDetailModel.name;
    description.value = restaurantDetailModel.description;
    streetController.text = restaurantDetailModel.street;
    locationController.text =
        "${restaurantDetailModel.latitude},${restaurantDetailModel.longitude}";
    imageSelectorController.setImageList(restaurantDetailModel.imageList);
    avatarSelectorController
        .setImage(ImageItem(url: restaurantDetailModel.avatar));
    hashtagController.setHashtags(restaurantDetailModel.hashtagList);
    defaultBrandId = restaurantDetailModel.brandId.toString();
    defaultCategoryId = restaurantDetailModel.restaurantCategoryId.toString();

    addressSelectorController.setDefaultAddress(
      provinceCode: restaurantDetailModel.province,
      districtCode: restaurantDetailModel.district,
      wardCode: restaurantDetailModel.ward,
    );

    brandSuggestionList = toBrandMapList(restaurantDetailModel.brandList);
    categorySuggestionList = toRestaurantCategoryMapList(
        restaurantDetailModel.restaurantCategoryList);
  }
}

/*
    p_id INT,
    p_name VARCHAR(255),
    p_restaurant_category_id INT,
    p_brand_id INT,
    p_description TEXT,
    p_hashtag_list TEXT[],
    p_image_urls TEXT[],
    p_avatar_url TEXT,
    p_province VARCHAR(255),
    p_district VARCHAR(255),
    p_ward VARCHAR(255),
    p_street VARCHAR(255),
    p_latitude DOUBLE PRECISION,
    p_longitude DOUBLE PRECISION,
    p_metadata_id INT DEFAULT NULL,
    p_avatar_id INT DEFAULT NULL,
    p_address_id INT DEFAULT NULL,
    p_location_id INT DEFAULT NULL
*/

/*
  p_id,
    p_name,
     p_restaurant_category_id, 
  p_brand_id, 
  p_description, 
  p_hashtag_list, 
   p_image_urls, 
p_address_id,
 p_avatar_id,
  p_avatar_url, 
     p_province, 
  p_district, 
     p_ward
     p_street, 
   p_latitude,
    p_location_id, 
   p_longitude, 
   p_metadata,
*/

//=========Error upserting restaurant: 
//Error occurred: 
//insert or update on table "restaurant" violates foreign key constraint "restaurant_image_id_fkey"=========