import 'dart:convert';

import 'package:smart_fin/data/models/spending_jar.dart';

class User {
  // String id;
  String username;
  String email;
  String token;
  String fullName;
  String? phoneNumber;
  String? gender;
  String? nickname;
  String? profileImage;
  String? dob;
  List<SpendingJar>? spendingJars;
  User({
    // required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.token,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        // id: json["id"] ?? "",
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        fullName: json["full_name"] ?? "",
        token: json["token"] ?? "",
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        // "id": id,
        "username": username,
        "email": email,
        "full_name": fullName,
      };
}
