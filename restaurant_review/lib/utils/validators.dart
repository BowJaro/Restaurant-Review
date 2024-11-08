import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';

class ValidatorUtils {
  /// Validate an email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(
          Get.context!, "authentication.require_email");
    }

    // Email regex pattern for basic validation
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return FlutterI18n.translate(
          Get.context!, "authentication.invalid_email");
    }
    return null; // Email is valid
  }

  /// Validate a phone number (simple pattern, country-specific could vary)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(
          Get.context!, "authentication.require_phone");
    }

    // Phone number pattern for a basic international format (+1234567890)
    String phonePattern = r'^\+?[0-9]{7,15}$';
    RegExp regex = RegExp(phonePattern);
    if (!regex.hasMatch(value)) {
      return FlutterI18n.translate(
          Get.context!, "authentication.invalid_phone");
    }
    return null; // Phone number is valid
  }

  /// Validate a password (at least 8 characters, includes a number and a special character)
  static String? validatePassword(String? value) {
    print("validateCoordinates called with value: $value");
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(
          Get.context!, "authentication.require_password");
    }

    // Password pattern: at least 8 characters, one letter, one number, one special char
    String passwordPattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regex = RegExp(passwordPattern);
    if (!regex.hasMatch(value)) {
      return FlutterI18n.translate(
          Get.context!, "authentication.invalid_password");
    }
    return null; // Password is valid
  }

  static String? validateCoordinates(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(Get.context!, "error.invalid_coordinates");
    }

    final coordinates = value.split(",");
    if (coordinates.length != 2) {
      return FlutterI18n.translate(Get.context!, "error.invalid_coordinates");
    }

    double tryParse(String s) {
      try {
        return double.parse(s);
      } on FormatException {
        return double.nan;
      }
    }

    final lat = tryParse(coordinates[0]);
    final lon = tryParse(coordinates[1]);

    if (lat.isNaN ||
        lon.isNaN ||
        lat < -90 ||
        lat > 90 ||
        lon < -180 ||
        lon > 180) {
      return FlutterI18n.translate(Get.context!, "error.invalid_coordinates");
    }

    return null;
  }
}
