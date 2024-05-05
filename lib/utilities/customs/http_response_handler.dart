import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

void httpResponseHandler({
  required BuildContext context,
  required http.Response response,
  required Function onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 201:
      onSuccess();
      break;
    case 400:
      showCustomSnackBar(context, jsonDecode(response.body)["message"],
          Constant.contentTypes["failure"]!);
      break;
    case 404:
      // showCustomSnackBar(context, jsonDecode(response.body)["message"]);
      break;
    case 500:
      showCustomSnackBar(context, "Server error!", Constant.contentTypes["failure"]!);
      // showCustomSnackBar(context, jsonDecode(response.body)["message"]);
      break;
    default:
      showCustomSnackBar(context, jsonDecode(response.body)["message"],
          Constant.contentTypes["help"]!);
  }
}
