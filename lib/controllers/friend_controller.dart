import 'package:smart_fin/utilities/constants/constants.dart';

class FriendController {
  String? validateSourceName(String? value) {
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
}