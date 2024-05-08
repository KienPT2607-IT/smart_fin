import 'package:smart_fin/utilities/constants/constants.dart';

class ExpenseCategoryController {
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a name";
    }
    if (!RegExp(Constant.nameRegex).hasMatch(value)) {
      return "Name must contain only letters and spaces";
    }
    if (value.length < 3) {
      return "Name must have at least than 3 characters";
    }
    return null;
  }
}
