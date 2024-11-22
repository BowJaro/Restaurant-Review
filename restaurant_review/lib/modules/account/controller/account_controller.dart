import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/modules/account/model/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../global_widgets/image_widgets/avatar_selector.dart';
import '../../../global_widgets/modals/modals.dart';
import '../repository/account_repository.dart';

class AccountController extends GetxController {
  final AccountRepository repository;

  AccountController(this.repository);
  var isLoading = true.obs;

  final AvatarSelectorController avatarSelectorController =
      Get.put(AvatarSelectorController());

  late final String email;
  late final String fullName;
  late final String sessionId;

  @override
  void onInit() async {
    super.onInit();
    print(
        "this is sessionId: ${(await SharedPreferences.getInstance()).getString('sessionId')}");

    sessionId = (await SharedPreferences.getInstance()).getString('sessionId')!;
    fetchAccount();
  }

  @override
  void onClose() {
    avatarSelectorController.dispose();
    super.onClose();
  }

  Future<void> fetchAccount() async {
    isLoading.value = true;
    final response = await repository.fetchAccount(sessionId);

    if (response != null) {
      final accountModel = AccountModel.fromMap(response);
      email = accountModel.email ?? "email_user";
      fullName = accountModel.fullName ?? "fullName_user";
      avatarSelectorController.setImage(accountModel.image);
      isLoading.value = false;
    } else {
      Get.back();
      ModalUtils.showMessageModal(
          FlutterI18n.translate(Get.context!, "error.unknown"));
    }
  }
}
