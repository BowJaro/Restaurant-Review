import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/account_controller.dart';
import '../provider/account_provider.dart';
import '../repository/account_repository.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountProvider>(() => AccountProvider(supabase));
    Get.lazyPut<AccountRepository>(
        () => AccountRepository(Get.find<AccountProvider>()));
    Get.lazyPut<AccountController>(
        () => AccountController(Get.find<AccountRepository>()));
  }
}
