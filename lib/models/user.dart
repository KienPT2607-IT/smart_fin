import 'dart:convert';

class User {
  String id;
  String username;
  String email;
  String password;
  String token;
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.token,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? "",
        username: json["username"] ?? "",
        password: json["password"] ?? "",
        email: json["email"] ?? "",
        token: json["token"] ?? "",
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
      };
}
