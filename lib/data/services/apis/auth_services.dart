import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/data/models/user.dart';
import 'package:smart_fin/utilities/utilities.dart';
import 'package:smart_fin/screens/note_tracker_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "${Constant.urlPath}/users";

  // * login
  void login({
    required BuildContext context,
    required String username,
    required String password,
  }) {
    try {
      Future<http.Response> res = http.post(
        Uri.parse("$baseUrl/login"),
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
        headers: <String, String>{
          "Content-type":
              "application/json; charset=utf-8" // ! utf-8 not UTF-8 because of case sensitivity
        },
      );

      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      res.then((res) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            userProvider.setUser(res.body);
            await prefs.setString(
              "x-auth-token",
              jsonDecode(res.body)["token"],
            );
            navigator.pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const NoteTrackerScreen(),
              ),
              (route) => false,
            );
          },
        );
      });
    } on Exception catch (e) {
      showCustomSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }

  void register({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) {
    try {
      User user = User(
        id: "",
        username: username,
        password: password,
        email: email,
        token: "",
      );

      Future<http.Response> res = http.post(
        Uri.parse("$baseUrl/register"),
        body: user.toRawJson(),
        headers: <String, String>{
          "Content-type":
              "application/json; charset=utf-8" // ! utf-8 not UTF-8 because of case sensitivity
        },
      );

      res.then((res) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showCustomSnackBar(
              context,
              "Account created! Login with the same credential!",
            );
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e.toString());
    }
  }
}
