import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../repository/saved_repository.dart';

class SavedController extends GetxController {
  final baseImageUrl = dotenv.env['BASE_IMAGE_URL']!;
  final SavedRepository repository;
  var isLoadingAccountPage = false.obs;

  SavedController(this.repository);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
