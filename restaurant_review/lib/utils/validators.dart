class ValidatorUtils {
  /// Validate an email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Email regex pattern for basic validation
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null; // Email is valid
  }

  /// Validate a phone number (simple pattern, country-specific could vary)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Phone number pattern for a basic international format (+1234567890)
    String phonePattern = r'^\+?[0-9]{7,15}$';
    RegExp regex = RegExp(phonePattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null; // Phone number is valid
  }

  /// Validate a password (at least 8 characters, includes a number and a special character)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Password pattern: at least 8 characters, one letter, one number, one special char
    String passwordPattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    RegExp regex = RegExp(passwordPattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long and include a number and special character';
    }
    return null; // Password is valid
  }
}
