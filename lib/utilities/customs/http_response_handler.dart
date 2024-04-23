import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

void httpResponseHandler({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 201:
      onSuccess();
      break;
    case 400:
      showCustomSnackBar(context, response.body);
      break;
    case 404:
      // showCustomSnackBar(context, "No content found!");
      break;
    case 500:
      // showCustomSnackBar(context, "Server error!");
      showCustomSnackBar(context, response.body);
      break;
    default:
      showCustomSnackBar(context, response.body);
  }
}
