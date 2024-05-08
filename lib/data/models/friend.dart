import 'dart:convert';

class Friend {
  String id;
  String name;
  String phoneNumber;
  String email;
  bool status;
  
  Friend({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.status,
  });

  factory Friend.fromRawJson(String str) => Friend.fromJson(jsonDecode(str));

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"] ?? "",
        email: json["email"] ?? "",
        status: json["status"],
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "email": email,
        "status": status,
      };
}
