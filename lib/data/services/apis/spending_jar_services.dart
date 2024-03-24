import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/spending_jar.dart';
import 'package:smart_fin/data/services/providers/spending_jars_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

class SpendingJarService {
  static const String _baseUrl = "${Constant.baseUrlPath}/spending_jars";

  void createNewJar({
    required BuildContext context,
    required String name,
    required double currentAmount,
    required String icon,
    required int color,
  }) {
    final String token =
        Provider.of<UserProvider>(context, listen: false).user.token;
    var spendingJarProvider =
        Provider.of<SpendingJarsProvider>(context, listen: false);
    Future<http.Response> res = http.post(
      Uri.parse("$_baseUrl/create"),
      body: jsonEncode({
        "name": name,
        "current_amount": currentAmount,
        "icon": icon,
        "color": color,
      }),
      headers: <String, String>{
        "Content-type": "application/json; charset=utf-8",
        "x-auth-token": token,
      },
    );

    res.then((res) {
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          spendingJarProvider.addSpendingJar(
            SpendingJar(
              id: jsonDecode(res.body)["id"],
              name: name,
              currentAmount: currentAmount,
              icon: icon,
              color: color,
            ),
          );
        },
      );
    });
  }

  void getJars({required BuildContext context}) {
    final String token =
        Provider.of<UserProvider>(context, listen: false).user.token;
    var spendingJarProvider =
        Provider.of<SpendingJarsProvider>(context, listen: false);

    Future<http.Response> res = http.get(
      Uri.parse("$_baseUrl/"),
      headers: <String, String>{
        "Content-type": "application/json; charset=utf-8",
        "x-auth-token": token,
      },
    );

    res.then((res) {
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          List<SpendingJar> jars = [];
          jsonDecode(res.body)["data"].forEach((jar) {
            print(jar);
            // SpendingJar x = SpendingJar(
            //   // id: jar["id"],
            //   // name: jar["name"],
            //   currentAmount: double.parse(jar["current_amount"]),
            //   // icon: jar["icon"],
            //   // // color: jar["color"] as int,
            //   // color: 4293943954,
            // );
            // print("${x.currentAmount} ---- ${x.currentAmount.runtimeType}");
            var x = jar["current_amount"] as double;
            print(x.runtimeType);
            // jars.add(SpendingJar(
            //   id: jar["id"],
            //   // name: jar["name"],
            //   // currentAmount: double.parse(jar["current_amount"]),
            //   // icon: jar["icon"],
            //   // // color: jar["color"] as int,
            //   // color: 4293943954,
            // ));
          });
          spendingJarProvider.setSpendingJars(jars);
        },
      );
    });
  }
}
