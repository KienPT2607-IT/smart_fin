import 'dart:convert';

import 'package:flutter/material.dart';
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
    String token = Provider.of<UserProvider>(context, listen: false).getToken();
    var res = http.get(
      Uri.parse("$_baseUrl/"),
      headers: {
        "Content-type": "application/json; charset=utf-8",
        "x-auth-token": token,
      },
    );
    var friendProvider = Provider.of<FriendProvider>(context, listen: false);
    res.then((res) => httpResponseHandler(
          context: context,
          response: res,
          onSuccess: () {
            friendProvider.setFriends(res.body);
          },
        ));
  }

  void updateFriend() {}

  void removeFriend() {}
}
