
import 'package:mcd/core/constants/app_strings.dart';
import 'package:mcd/core/utils/logger.dart';

class CustomValidator {
  static bool validEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Define a regular expression pattern for a valid password
    RegExp passwordRegExp = RegExp(r'^(?=.*[a-zA-Z0-9])(?=.*[!@#$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]{6,}$');

    // Check if the password matches the pattern
    var data = passwordRegExp.hasMatch(password);
    logger.d(data);
    return data;
  }

  /// Strong password validation - minimum 8 characters, must start with uppercase
  /// Must contain: uppercase, lowercase, number, special character
  static String? validateStrongPassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }

    if (password.length < 8) {
      return "Password must be at least 8 characters";
    }

    // Must start with uppercase letter
    if (!RegExp(r'^[A-Z]').hasMatch(password)) {
      return "Password must start with an uppercase letter";
    }

    // Must contain at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
    }

    // Must contain at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter";
    }

    // Must contain at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one number";
    }

    // Must contain at least one special character
    if (!RegExp(r'''[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;'`~]''').hasMatch(password)) {
      return "Password must contain at least one special character";
    }

    return null; // Password is valid
  }

  /// Check individual password requirements
  static bool hasMinLength(String password) => password.length >= 8;
  static bool startsWithUppercase(String password) => RegExp(r'^[A-Z]').hasMatch(password);
  static bool hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);
  static bool hasLowercase(String password) => RegExp(r'[a-z]').hasMatch(password);
  static bool hasNumber(String password) => RegExp(r'[0-9]').hasMatch(password);
  static bool hasSpecialChar(String password) => RegExp(r'''[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;'`~]''').hasMatch(password);

  /// Calculate password strength (0-4)
  /// 0: Very Weak, 1: Weak, 2: Fair, 3: Strong, 4: Excellent
  static int calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;
    
    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    
    // Character variety
    if (hasUppercase(password) && hasLowercase(password)) strength++;
    if (hasNumber(password)) strength++;
    if (hasSpecialChar(password)) strength++;
    
    // Must start with uppercase to be considered strong
    if (!startsWithUppercase(password) && strength > 2) {
      strength = 2; // Cap at Fair if doesn't start with uppercase
    }
    
    return strength > 4 ? 4 : strength;
  }

  /// Get password strength label
  static String getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
        return "Very Weak";
      case 1:
        return "Weak";
      case 2:
        return "Fair";
      case 3:
        return "Strong";
      case 4:
        return "Excellent";
      default:
        return "Very Weak";
    }
  }

  static bool isValidAccountNumber(String accountNumber) {
    return RegExp(r'^\d{10}$').hasMatch(accountNumber);
  }

  static String? isEmptyString(String value, String valueName) {
    if (value.isEmpty) return "$valueName ${AppStrings.emptyString}";
    return null;
  }
}
