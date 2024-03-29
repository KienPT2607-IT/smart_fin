import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:http/http.dart' as http;

class ExpenseNoteService {
  static final String _baseUrl = "${Constant.baseUrlPath}/expenses";

  void createExpenseNote({
    required BuildContext context,
    required String moneyJarId,
    required double amount,
    required DateTime date,
    required String note,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user.token;
      Future<http.Response> res = http.post(
        Uri.parse("$_baseUrl/create"),
        body: jsonEncode({
          "money_jar": moneyJarId,
          "amount": amount,
          "create_at": date.toIso8601String(),
          "note": note,
        }),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      res.then((value) => httpErrorHandle(
            context: context,
            response: value,
            onSuccess: () {
              showCustomSnackBar(context, "Expense note saved!");
              //TODO: update the used money jar balance
            },
          ));
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void getExpenseNotes({
    required BuildContext context,
  }) {}

  void updateExpenseNote() {}

  void changeExpenseCategory() {}

  void deleteExpenseNote() {}
}
