import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/customs/http_response_handler.dart';

class MoneyJarService {
  static final String _baseUrl = "${Constant.baseUrlPath}/money_jars";

  void createNewJar({
    required BuildContext context,
    required String name,
    required double balance,
    required String icon,
    required int color,
  }) {
    try {
      final String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      Future<http.Response> res = http.post(
        Uri.parse("$_baseUrl/create"),
        body: jsonEncode({
          "name": name,
          "balance": balance,
          "icon": icon,
          "color": color,
        }),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      res.then((res) {
        httpResponseHandler(
          response: res,
          context: context,
          onSuccess: () {
            var jarProvider =
                Provider.of<MoneyJarProvider>(context, listen: false);
            jarProvider.addJar(MoneyJar(
              id: jsonDecode(res.body)["id"],
              name: name,
              balance: balance,
              icon: icon,
              color: color,
              status: true,
            ));
          },
        );
      });
    } on Exception catch (e) {
      showCustomSnackBar(context, e.toString(), Constant.contentTypes["failure"]!);
    }
  }

  void getJars({required BuildContext context}) {
    try {
      final String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      Future<http.Response> res = http.get(
        Uri.parse("$_baseUrl/"),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      var jarProvider = Provider.of<MoneyJarProvider>(context, listen: false);
      res.then((res) {
        httpResponseHandler(
          response: res,
          context: context,
          onSuccess: () {
            jarProvider.setJars(res.body);
          },
        );
      });
    } on Exception catch (e) {
      showCustomSnackBar(context, e.toString(), Constant.contentTypes["failure"]!);
    }
  }
}
