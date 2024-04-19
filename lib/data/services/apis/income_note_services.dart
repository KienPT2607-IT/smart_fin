import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/income.dart';
import 'package:smart_fin/data/services/providers/income_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:http/http.dart' as http;

class IncomeNoteService {
  static final _baseUrl = "${Constant.baseUrlPath}/incomes";

  void createNote({
    required BuildContext context,
    required double amount,
    required String note,
    required DateTime createAt,
    required String moneyJar,
    required String incomeSource,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.post(
        Uri.parse("$_baseUrl/create"),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "amount": amount,
          "create_at": createAt.toIso8601String(),
          "note": note,
          "money_jar": moneyJar,
          "income_source": incomeSource,
        }),
      );

      res.then(
        (res) => httpErrorHandle(
          context: context,
          response: res,
          onSuccess: () {
            var incomeProvider =
                Provider.of<IncomeProvider>(context, listen: false);
            var jarProvider =
                Provider.of<MoneyJarProvider>(context, listen: false);
            jarProvider.updateBalance(
              id: moneyJar,
              amount: amount,
              isIncreased: true,
            );
            String id = jsonDecode(res.body)["id"];
            incomeProvider.addIncome(Income(
              id: id,
              amount: amount,
              createAt: createAt,
              note: note,
              moneyJar: moneyJar,
              jarBalance: jarProvider.getBalance(moneyJar),
              incomeSource: incomeSource,
            ));
          },
        ),
      );
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void getNotes({required BuildContext context}) {
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
        (res) => httpErrorHandle(
          context: context,
          response: res,
          onSuccess: () {
            var incomeProvider =
                Provider.of<IncomeProvider>(context, listen: false);
            incomeProvider.setIncomes(res.body);
          },
        ),
      );
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }
}

