import 'package:smart_fin/utilities/constants/constants.dart';

class AccountController {
  String? validateUsername(String? value) {
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email address";
    }
    if (!RegExp(Constant.emailRegex).hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 8 || value.length > 16) {
      return "Password must be between 8 and 16 characters";
    }
    if (!RegExp(Constant.passwordRegex).hasMatch(value)) {
      return "Password must have an uppercase letter, digit, and special character";
    }
    return null;
  }

  String? validatePassConf(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm the password";
    } else if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your full name";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }
    if (!RegExp(Constant.phoneRegex).hasMatch(value)) {
      return "Phone number must be 10 digits long and start with 0";
    }
    return null;
  }
}
