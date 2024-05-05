import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context, String message, String contentType) {
  String title = _getTitle(contentType);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: _getContentType(contentType),
      ),
    ),
  );
}

String _getTitle(String contentType){
  switch (contentType) {
    case "success":
      return "Congratulations!";
    case "warning":
      return "Warning!";
    case "help":
      return "Hi there!";
    case "failure":
      return "Opps!";
    default:
      return "Hi there!";
  }
}

ContentType _getContentType(String contentType) {
  switch (contentType) {
    case "success":
      return ContentType.success;
    case "warning":
      return ContentType.warning;
    case "help":
      return ContentType.help;
    case "failure":
      return ContentType.failure;
    default:
      return ContentType.help;
  }
}
