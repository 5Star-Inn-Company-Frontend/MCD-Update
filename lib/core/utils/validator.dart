
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
static bool isValidAccountNumber(String accountNumber) {
  return RegExp(r'^\d{10}$').hasMatch(accountNumber);
}

static String? isEmptyString(String value, String valueName){
    if(value.isEmpty)return "${valueName} ${AppStrings.emptyString}";
    return null;
}
}