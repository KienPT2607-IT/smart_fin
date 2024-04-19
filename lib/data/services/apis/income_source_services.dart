import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

class IncomeSourceService {
  static final String _baseUrl = "${Constant.baseUrlPath}/income_sources";

  void createNewSource({
    required BuildContext context,
    required String name,
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
          "icon": icon,
          "color": color,
        }),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      var sourceProvider =
          Provider.of<IncomeSourceProvider>(context, listen: false);
      res.then((res) => httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              sourceProvider.addSource(IncomeSource(
                id: jsonDecode(res.body)["id"],
                name: name,
                icon: icon,
                color: color,
              ));
            },
          ));
    } on Exception catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void getSources({required BuildContext context}) {
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

      var sourceProvider =
          Provider.of<IncomeSourceProvider>(context, listen: false);
      res.then((res) => httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () => sourceProvider.setSources(res.body),
          ));
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }
}
