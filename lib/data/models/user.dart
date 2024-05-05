import 'dart:convert';

import 'package:intl/intl.dart';

class User {
  String username;
  String email;
  String token;
  String fullName;
  String? phoneNumber;
  String? gender;
  String? profileImage;
  DateTime? dob;
  User({
    required this.username,
    required this.email,
    required this.fullName,
    required this.token,
    this.phoneNumber,
    this.gender,
    this.profileImage,
    this.dob,
  });
  factory User.fromRawJson(String str) => User.fromJson(jsonDecode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        fullName: json["full_name"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        gender: json["gender"] ?? "Unknown",
        profileImage: json["profile_image"] ?? "",
        dob: json["dob"] != null
            ? DateFormat('yyyy-MM-dd').parse(json["dob"])
            : null,
        token: json["token"] ?? "",
      );
}
