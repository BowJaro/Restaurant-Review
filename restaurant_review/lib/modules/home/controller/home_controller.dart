import 'package:get/get.dart';
import 'package:restaurant_review/services/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    final session = supabase.auth.currentSession;
    final prefs = await SharedPreferences.getInstance();

    if (session != null) {
      await prefs.setString('sessionId', session.user.id);
      print("test plash");
      print(
          "this is sessionId in splash: ${(await SharedPreferences.getInstance()).getString('sessionId')}");
    } else {
      await prefs.remove('sessionId');
    }
  }
}
