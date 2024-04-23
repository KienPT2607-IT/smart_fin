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

  void addFriend({
    required BuildContext context,
    required String name,
    required String phoneNumber,
    required String email,
  }) {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user.token;
      var res = http.post(Uri.parse("$_baseUrl/add"),
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "x-auth-token": token,
          },
          body: jsonEncode({
            "name": name,
            "phone_number": phoneNumber,
            "email": email,
          }));
      var friendProvider = Provider.of<FriendProvider>(context, listen: false);
      res.then((res) => httpResponseHandler(
            context: context,
            response: res,
            onSuccess: () {
              friendProvider.addFriend(Friend(
                id: jsonDecode(res.body)["id"],
                name: name,
                phoneNumber: phoneNumber,
                email: email,
              ));
            },
          ));
    } catch (e) {
      showCustomSnackBar(context, e.toString());
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
