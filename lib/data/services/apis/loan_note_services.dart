import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/loan.dart';
import 'package:smart_fin/data/services/providers/loan_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/customs/http_response_handler.dart';

class LoanNoteService {
  static final String _baseUrl = "${Constant.baseUrlPath}/loans";

  void createLoan({
    required BuildContext context,
    required String participantId,
    required String participantName,
    required double amount,
    required String note,
    required bool isCreatorLender,
    required DateTime createAt,
    required String moneyJarId,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.post(
        Uri.parse("$_baseUrl/create/"),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "participant_id": participantId,
          "participant_name": participantName,
          "amount": amount,
          "note": note,
          "is_repaid": false,
          "is_creator_lender": isCreatorLender,
          "create_at": createAt.toIso8601String(),
          "money_jar": moneyJarId,
        }),
      );
      var loanProvider = Provider.of<LoanProvider>(context, listen: false);
      var moneyJarProvider =
          Provider.of<MoneyJarProvider>(context, listen: false);
      res.then((res) => httpResponseHandler(
            context: context,
            response: res,
            onSuccess: () {
              moneyJarProvider.updateBalance(
                jarId: moneyJarId,
                amount: amount,
                isIncreased: isCreatorLender ? false : true,
              );
              loanProvider.addLoan(Loan(
                id: jsonDecode(res.body)["id"],
                participantId: participantId,
                participantName: participantName,
                amount: amount,
                note: note,
                isRepaid: false,
                isCreatorLender: isCreatorLender,
                createAt: createAt,
                moneyJar: moneyJarId,
                jarBalance: moneyJarProvider.getBalance(moneyJarId),
              ));
            },
          ));
    } on Exception catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void getLoans({
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
      var loanProvider = Provider.of<LoanProvider>(context, listen: false);
      res.then(
        (res) => httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            loanProvider.setLoans(res.body);
          },
        ),
      );
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void updateNote({
    required BuildContext context,
    required String loanId,
    required String note,
  }) {
    try {
      final String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.put(
        Uri.parse("$_baseUrl/update/$loanId/note"),
        body: jsonEncode({"note": note}),
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
            var loanProvider =
                Provider.of<LoanProvider>(context, listen: false);
            loanProvider.updateLoanNote(loanId, note);
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void updateRepaidStatus({
    required BuildContext context,
    required String loanId,
  }) {
    try {
      final String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.put(
        Uri.parse("$_baseUrl/update/$loanId/repaid"),
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
            var loanProvider = Provider.of<LoanProvider>(context, listen: false);
            loanProvider.updateRepaidStatus(loanId);
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void deleteNote() {}
}
