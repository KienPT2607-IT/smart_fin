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
import 'package:smart_fin/utilities/customs/http_response_handler.dart';

class ExpenseNoteService {
  static final String _baseUrl = "${Constant.baseUrlPath}/expenses";

  void createExpense({
    required BuildContext context,
    required String jarId,
    required double amount,
    required DateTime date,
    required String note,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.post(
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

      res.then((res) => httpResponseHandler(
            context: context,
            response: res,
            onSuccess: () {
              var jarProvider =
                  Provider.of<MoneyJarProvider>(context, listen: false);
              var expProvider =
                  Provider.of<ExpenseProvider>(context, listen: false);
              jarProvider.updateBalance(
                jarId: jarId,
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

  void getExpenses({
    required BuildContext context,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.get(
        Uri.parse("$_baseUrl/"),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      res.then(
        (res) => httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            var expProvider =
                Provider.of<ExpenseProvider>(context, listen: false);
            expProvider.setExpenses(res.body);
          },
        ),
      );
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void updateNote({
    required BuildContext context,
    required String expenseId,
    required String note,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.put(
        Uri.parse("$_baseUrl/update/$expenseId/note/"),
        body: jsonEncode({
          "note": note,
        }),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      res.then((value) {
        httpResponseHandler(
          context: context,
          response: value,
          onSuccess: () {
            var expenseProvider =
                Provider.of<ExpenseProvider>(context, listen: false);
            expenseProvider.updateExpenseNote(expenseId, note);
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void updateCategory({
    required BuildContext context,
    required String expenseId,
    required String categoryId,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.put(
        Uri.parse("$_baseUrl/update/$expenseId/category"),
        body: jsonEncode({
          "category_id": categoryId,
        }),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      res.then((res) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            var expenseProvider =
                Provider.of<ExpenseProvider>(context, listen: false);
            expenseProvider.updateExpenseCategory(expenseId, categoryId);
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void deleteExpense({
    required BuildContext context,
    required String expenseId,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.delete(
        Uri.parse("$_baseUrl/delete/$expenseId"),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      res.then((res) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            var expenseProvider =
                Provider.of<ExpenseProvider>(context, listen: false);
            var moneyJarProvider =
                Provider.of<MoneyJarProvider>(context, listen: false);
            Expense expense = expenseProvider.getExpenseById(expenseId);

            moneyJarProvider.updateBalance(
              jarId: expense.moneyJar,
              amount: expense.amount,
              isIncreased: true,
            );
            expenseProvider.removeExpenseById(expenseId);
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }
}
