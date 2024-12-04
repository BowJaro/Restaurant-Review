import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';
import 'package:restaurant_review/global_classes/rate.dart';
import 'package:restaurant_review/global_widgets/modals/modals.dart';
import 'package:restaurant_review/modules/feed/model/post_detail_model.dart';
import 'package:restaurant_review/routes/routes.dart';
import '../repository/feed_repository.dart';

class FeedController extends GetxController {
  final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
  final FeedRepository repository;
  var isLoadingAccountPage = false.obs;

  List<RateModel> rateList = [
    RateModel(
      id: 1,
      rateTypeId: 1, // e.g., Taste
      name: 'Taste',
      value: RxDouble(4.2), // Random value between 0 and 5
    ),
    RateModel(
      id: 2,
      rateTypeId: 2, // e.g., Service
      name: 'Service',
      value: RxDouble(3.8),
    ),
    RateModel(
      id: 3,
      rateTypeId: 3, // e.g., Price
      name: 'Price',
      value: RxDouble(4.5),
    ),
    RateModel(
      id: 4,
      rateTypeId: 4, // e.g., Ambiance
      name: 'Ambiance',
      value: RxDouble(3.2),
    ),
    RateModel(
      id: 5,
      rateTypeId: 5, // e.g., Cleanliness
      name: 'Cleanliness',
      value: RxDouble(4.0),
    ),
  ];

  final List<PostDetail> postList = [];
  FeedController(this.repository);

  @override
  void onInit() async {
    super.onInit();
    if (userId == null) {
      Get.offAllNamed(Routes.splash);
    }
    await fetchFollowingPostList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchFollowingPostList() async {
    isLoadingAccountPage.value = true;
    final response = await repository.getListFollowingPost(userId!, 5);
    if (response != null) {
      print('response: ${response}');
      postList.addAll((response as List<dynamic>)
          .map((item) => PostDetail.fromMap(item as Map<String, dynamic>))
          .toList());
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
    isLoadingAccountPage.value = false;
  }
}
