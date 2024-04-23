import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/category.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/customs/http_response_handler.dart';

class CategoryService {
  static final String _baseUrl = "${Constant.baseUrlPath}/categories";

  void createNewCategory({
    required BuildContext context,
    required String name,
    required String icon,
    required int color,
  }) {
    try {
      final String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.post(
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
      res.then((res) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            var categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);
            categoryProvider.addCategory(Category(
              id: jsonDecode(res.body)["id"],
              name: name,
              icon: icon,
              color: color,
            ));
          },
        );
      });
    } on Exception catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  void getCategories({required BuildContext context}) {
    try {
      final String token = Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.get(
        Uri.parse("$_baseUrl/"),
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
            var categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);
            categoryProvider.setCategories(res.body);
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }
}
