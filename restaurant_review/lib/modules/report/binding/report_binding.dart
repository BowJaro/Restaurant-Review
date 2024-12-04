import 'package:get/get.dart';
import 'package:restaurant_review/constants/singleton_variables.dart';

import '../controller/report_controller.dart';
import '../provider/report_provider.dart';
import '../repository/report_repository.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportProvider>(() => ReportProvider(supabase));
    Get.lazyPut<ReportRepository>(
        () => ReportRepository(Get.find<ReportProvider>()));
    Get.lazyPut<ReportController>(
        () => ReportController(Get.find<ReportRepository>()));
  }
}
