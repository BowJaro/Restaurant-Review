import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/services/base_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../provider/sign_in_provider.dart';

class SignInRepository {
  final SignInProvider authProvider;

  SignInRepository(this.authProvider);

  Future<BaseResponse> signIn(String email, String password) async {
    try {
      final response = await authProvider.signIn(email, password);

      if (response is AuthResponse) {
        return BaseResponse(
          isSuccess: true,
          message: FlutterI18n.translate(
              Get.context!, "authentication.sign_in_succeeded"),
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
