import 'package:smart_fin/utilities/constants/constants.dart';

class SpendingJarController {
  String? validateJarName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a jar name";
    }
    if (!RegExp(Constant.nameRegex).hasMatch(value)) {
      return "Jar name must contain only letters and spaces";
    }
    if (value.length < 3) {
      return "Jar name must have at least than 3 characters";
    }
    return null;
  }

  String? validateCurrentAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter an amount";
    }
    if (double.tryParse(value.replaceAll(",", ".")) == null) {
      return "Please enter a valid number";
    }
    return null;
  }
}
