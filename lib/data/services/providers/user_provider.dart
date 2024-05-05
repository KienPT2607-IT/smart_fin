import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/user.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  UserProvider() {
    _user = User(
      username: "",
      email: "",
      fullName: "",
      token: "",
      phoneNumber: "",
      gender: "Unknown",
      profileImage: "",
      dob: null,
    );
  }

  User get user => _user;

  String getToken() {
    return _user.token;
  }

  void setUser(String userRawJson) {
    _user = User.fromRawJson(userRawJson);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String gender,
    required DateTime dob,
  }) {
    _user.fullName = fullName;
    _user.email = email;
    _user.phoneNumber = phoneNumber;
    _user.gender = gender;
    _user.dob = dob;
    notifyListeners();
  }

  void removeUser() {
    _user = User(
      username: "",
      email: "",
      fullName: "",
      token: "",
      phoneNumber: "",
      gender: "Unknown",
      profileImage: "",
      dob: null,
    );
  }

  void updateProfileImage(String rawJson) {
    _user.profileImage = jsonDecode(rawJson)["profile_image"];
    notifyListeners();
  }
}
