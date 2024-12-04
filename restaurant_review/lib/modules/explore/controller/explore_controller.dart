import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../repository/explore_repository.dart';

class ExploreController extends GetxController {
  final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
  final ExploreRepository repository;
  var isLoadingAccountPage = false.obs;

  ExploreController(this.repository);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
