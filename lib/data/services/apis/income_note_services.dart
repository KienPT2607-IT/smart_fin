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
import 'package:smart_fin/utilities/customs/http_response_handler.dart';

class IncomeNoteService {
  static final _baseUrl = "${Constant.baseUrlPath}/incomes";

  void createIncome({
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
        (res) => httpResponseHandler(
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
      showCustomSnackBar(
          context, e.toString(), Constant.contentTypes["failure"]!);
    }
  }

  void getIncomes({required BuildContext context}) {
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
            var incomeProvider =
                Provider.of<IncomeProvider>(context, listen: false);
            incomeProvider.setIncomes(res.body);
          },
        ),
      );
    } catch (e) {
      showCustomSnackBar(
          context, e.toString(), Constant.contentTypes["failure"]!);
    }
  }

  void updateNote({
    required BuildContext context,
    required String incomeId,
    required String note,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.put(
        Uri.parse("$_baseUrl/update/$incomeId/note/"),
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
            var incomeProvider =
                Provider.of<IncomeProvider>(context, listen: false);
            incomeProvider.updateIncomeNote(incomeId, note);
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(
          context, e.toString(), Constant.contentTypes["failure"]!);
    }
  }

  Future<bool> deleteIncome({
    required BuildContext context,
    required String incomeId,
  }) async {
    bool result = false;
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = await http.delete(
        Uri.parse("$_baseUrl/delete/$incomeId"),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            var incomeProvider =
                Provider.of<IncomeProvider>(context, listen: false);
            var moneyJarProvider =
                Provider.of<MoneyJarProvider>(context, listen: false);
            Income income = incomeProvider.getIncomeById(incomeId);
            moneyJarProvider.updateBalance(
              id: income.moneyJar,
              amount: income.amount,
              isIncreased: false,
            );
            incomeProvider.removeIncome(incomeId);
            result = true;
          },
        );
      }
      return result;
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(
            context, e.toString(), Constant.contentTypes["failure"]!);
      }
      return result;
    }
  }
}
