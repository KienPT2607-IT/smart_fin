import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showCustomSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
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
      showCustomSnackBar(context, jsonDecode(response.body)["message"]);
      break;
    case 404:
    // TODO: handle the case when the server returns a 404 status code
      break;
    case 500:
      showCustomSnackBar(context, jsonDecode(response.body)["error"]);
      break;
    default:
      showCustomSnackBar(context, response.body);
  }
}
