import 'package:smart_fin/utilities/constants.dart';

class AccountController {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a username";
    }
    if (value.contains(" ")) {
      return "Username cannot have space";
    }
    if (value.length < 5 || value.length > 15) {
      return "Username must be between 5 and 15 characters";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email address";
    }
    if (!RegExp(Constant.emailRegex).hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 8 || value.length > 16) {
      return "Password must be between 8 and 16 characters";
    }
    if (!RegExp(Constant.passwordRegex).hasMatch(value)) {
      return "Password must have 1 uppercase letter, 1 digit, and 1 special character";
    }
    return null;
  }

  static String? validatePassConf(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm the password";
    } else if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
