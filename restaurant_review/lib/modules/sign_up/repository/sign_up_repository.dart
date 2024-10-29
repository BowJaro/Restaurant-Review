import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/services/base_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../provider/sign_up_provider.dart';

class SignUpRepository {
  final SignUpProvider authProvider;

  SignUpRepository(this.authProvider);

  Future<BaseResponse> signUp(String email, String password) async {
    try {
      final response = await authProvider.signUp(email, password);

      if (response is AuthResponse) {
        return BaseResponse(
          isSuccess: true,
          message: FlutterI18n.translate(
              Get.context!, "authentication.sign_up_succeeded"),
        );
      } else {
        final errorMessage = response ??
            FlutterI18n.translate(Get.context!, "error.unknown_error");
        return BaseResponse(isSuccess: false, message: errorMessage);
      }
    } catch (e) {
      return BaseResponse(isSuccess: false, message: e.toString());
    }
  }
}
