import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/expense.dart';
import 'package:smart_fin/data/services/providers/expense_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:http/http.dart' as http;

class ExpenseNoteService {
  static final String _baseUrl = "${Constant.baseUrlPath}/expenses";

  void createNote({
    required BuildContext context,
    required String jarId,
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
          "money_jar": jarId,
          "amount": amount,
          "create_at": date.toIso8601String(),
          "note": note,
        }),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      res.then((res) => httpErrorHandle(
            context: context,
            response: res,
            onSuccess: () {
              var jarProvider =
                  Provider.of<MoneyJarProvider>(context, listen: false);
              var expProvider =
                  Provider.of<ExpenseProvider>(context, listen: false);
              jarProvider.updateBalance(
                id: jarId,
                amount: amount,
                isIncreased: true,
              );
              expProvider.addExpense(Expense(
                id: jsonDecode(res.body)["id"],
                amount: amount,
                createAt: date,
                note: note,
                moneyJar: jarId,
                jarBalance: jarProvider.getBalance(jarId),
                category: "",
              ));
            },
          ));
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void getNotes({
    required BuildContext context,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      Future<http.Response> res = http.get(
        Uri.parse("$_baseUrl/"),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      var expProvider = Provider.of<ExpenseProvider>(context, listen: false);
      res.then(
        (res) => httpErrorHandle(
          context: context,
          response: res,
          onSuccess: () {
            expProvider.setExpenses(res.body);
          },
        ),
      );
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void updateNote() {}

  void changeNoteCategory() {}

  void deleteENote() {}
}
