import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/data/services/providers/expense_provider.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/data/services/providers/income_provider.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/data/services/providers/loan_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/screens/login_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_fin/utilities/customs/http_response_handler.dart';

class AuthService {
  static final String _baseUrl = "${Constant.baseUrlPath}/users";

  // * register
  Future<bool> register({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    bool result = false;
    try {
      var res = await http.post(
        Uri.parse("$_baseUrl/register"),
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
      if (context.mounted) {
        httpResponseHandler(
          response: res,
          context: context,
          onSuccess: () {
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

  // * login
  Future<bool> login({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    bool result = false;
    try {
      var res = await http.post(
        Uri.parse("$_baseUrl/login"),
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
        headers: <String, String>{
          "Content-type": "application/json; charset=utf-8"
        },
      );

      if (context.mounted) {
        httpResponseHandler(
          response: res,
          context: context,
          onSuccess: () {
            var userProvider =
                Provider.of<UserProvider>(context, listen: false);
            userProvider.setUser(res.body);
            result = true;
          },
        );
      }
      return result;
    } on Exception catch (e) {
      if (context.mounted) {
        showCustomSnackBar(
          context,
          e.toString(),
          Constant.contentTypes["failure"]!,
        );
      }
      return result;
    }
  }

  void updateProfilePicture({
    required BuildContext context,
    required File imageFile,
  }) async {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var request = http.MultipartRequest(
        "PUT",
        Uri.parse("$_baseUrl/update/avatar"),
      );
      request.headers.addAll(<String, String>{
        'Content-Type': 'multipart/form-data',
        'x-auth-token': token,
      });
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        imageFile.path,
      ));
      var streamedResponse = await request.send();
      var res = await http.Response.fromStream(streamedResponse);
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).updateProfileImage(res.body);
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(
          context,
          e.toString(),
          Constant.contentTypes["failure"]!,
        );
      }
    }
  }

  Future<bool> updateProfile({
    required BuildContext context,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String gender,
    required DateTime dob,
  }) async {
    bool result = false;
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user.token;
      var res = await http.put(
        Uri.parse("$_baseUrl/update/profile"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "full_name": fullName,
          "phone_number": phoneNumber,
          "email": email,
          "gender": gender,
          "dob": dob.toIso8601String(),
        }),
      );
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            Provider.of<UserProvider>(context, listen: false).updateProfile(
              fullName: fullName,
              email: email,
              phoneNumber: phoneNumber,
              gender: gender,
              dob: dob,
            );
            result = true;
          },
        );
      }
      return result;
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(
          context,
          e.toString(),
          Constant.contentTypes["failure"]!,
        );
      }
      return result;
    }
  }

  void logout(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove("x-auth-token");
    Provider.of<UserProvider>(context, listen: false).removeUser();
    Provider.of<ExpenseProvider>(context, listen: false).removeAll();
    Provider.of<LoanProvider>(context, listen: false).removeAll();
    Provider.of<IncomeProvider>(context, listen: false).removeAll();
    Provider.of<CategoryProvider>(context, listen: false).removeAll();
    Provider.of<IncomeSourceProvider>(context, listen: false).removeAll();
    Provider.of<MoneyJarProvider>(context, listen: false).removeAll();
    Provider.of<FriendProvider>(context, listen: false).removeAll();
  }

  void updatePassword({
    required BuildContext context,
    required String newPassword,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user.token;
      var res = http.put(
        Uri.parse("$_baseUrl/update/password"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
        body: jsonEncode({"password": newPassword}),
      );
      res.then((res) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {},
        );
      });
    } catch (e) {
      showCustomSnackBar(
        context,
        e.toString(),
        Constant.contentTypes["failure"]!,
      );
    }
  }
}
