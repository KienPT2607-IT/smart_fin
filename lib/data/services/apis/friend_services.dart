import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/friend.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:smart_fin/utilities/customs/http_response_handler.dart';

class FriendService {
  static final String _baseUrl = "${Constant.baseUrlPath}/friends";

  Future<bool> addFriend({
    required BuildContext context,
    required String name,
    required String phoneNumber,
    required String email,
  }) async {
    var result = false;
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user.token;
      var res = await http.post(
        Uri.parse("$_baseUrl/add"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "name": name,
          "phone_number": phoneNumber,
          "email": email,
        }),
      );
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            var friendProvider =
                Provider.of<FriendProvider>(context, listen: false);
            friendProvider.addFriend(Friend(
              id: jsonDecode(res.body)["id"],
              name: name,
              phoneNumber: phoneNumber,
              email: email,
              status: true,
            ));
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

  void getFriends({
    required BuildContext context,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = http.get(
        Uri.parse("$_baseUrl/"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );
      res.then((res) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            Provider.of<FriendProvider>(context, listen: false)
                .setFriends(res.body);
          },
        );
      });
    } on Exception catch (e) {
      showCustomSnackBar(
        context,
        e.toString(),
        Constant.contentTypes["failure"]!,
      );
    }
  }

  Future<bool> updateFriend({
    required BuildContext context,
    required String id,
    required String newName,
    required String newPhoneNumber,
    required String newEmail,
  }) async {
    bool result = false;
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = await http.put(
        Uri.parse("$_baseUrl/update/$id/detail"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          "name": newName,
          "phone_number": newPhoneNumber,
          "email": newEmail,
        }),
      );

      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            Provider.of<FriendProvider>(
              context,
              listen: false,
            ).updateFriend(Friend(
              id: id,
              name: newName,
              phoneNumber: newPhoneNumber,
              email: newEmail,
              status: true,
            ));
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

  Future<bool> removeFriend({
    required BuildContext context,
    required String id,
  }) async {
    bool result = false;
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).getToken();
      var res = await http.delete(
        Uri.parse("$_baseUrl/delete/$id"),
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "x-auth-token": token,
        },
      );

      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            Provider.of<FriendProvider>(context, listen: false)
                .removeFriend(id);
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
}
