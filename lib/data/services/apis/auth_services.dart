import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/screens/init_screen.dart';
import 'package:smart_fin/screens/login_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "${Constant.baseUrlPath}/users";

  // * register
  void register({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) {
    try {
      Future<http.Response> res = http.post(
        Uri.parse("$baseUrl/register"),
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
        headers: <String, String>{
          // ! utf-8 not UTF-8 because of case sensitivity
          "Content-type": "application/json; charset=utf-8"
        },
      );

      res.then((res) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showCustomSnackBar(
              context,
              "Account created! Login with your new account.",
            );
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

  // * update user information
  void updateUserInfor(
    String fullName,
    String phoneNumber,
    String gender,
    String dob, {
    required BuildContext context,
  }) {
    try {
      String token = "";
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((prefs) {
        token = prefs.getString("x-auth-token")!;
      });

      Future<http.Response> res = http.put(
        Uri.parse("$baseUrl/update/infor"),
        body: jsonEncode({
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "gender": gender,
          "dob": dob,
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
            showCustomSnackBar(context, "Information updated!");
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const InitScreen(),
              ),
              (route) => false,
            );
          },
        );
      });
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    }
  }

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
          "Content-type": "application/json; charset=utf-8"
        },
      );

      var userProvider = Provider.of<UserProvider>(context, listen: false);
      // final navigator = Navigator.of(context);

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
            // navigator.pushAndRemoveUntil(
            //   CupertinoPageRoute(
            //     builder: (context) => const InitScreen(),
            //   ),
            //   (route) => false,
            // );
          },
        );
      });
    } on Exception catch (e) {
      showCustomSnackBar(context, e.toString());
      debugPrint(e.toString());
    }
  }

  // Todo: Logout - Just generated
  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("x-auth-token");
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => const InitScreen(),
      ),
      (route) => false,
    );
  }
}
