import 'package:smart_fin/utilities/constants/constants.dart';

class FriendController {
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a name";
    }
    if (!RegExp(Constant.nameRegex).hasMatch(value)) {
      return "Source name must contain only letters and spaces";
    }
    if (value.length < 3) {
      return "Source name must have at least than 3 characters";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!RegExp(Constant.emailRegex).hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!RegExp(Constant.phoneRegex).hasMatch(value)) {
      return "Phone number must be 10 digits long and start with 0";
    }
    return null;
  }
}
