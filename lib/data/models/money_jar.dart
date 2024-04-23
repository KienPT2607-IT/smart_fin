import 'dart:convert';

class MoneyJar {
  String id;
  String name;
  double balance;
  String icon;
  int color;
  bool status;

  MoneyJar({
    required this.id,
    required this.name,
    required this.balance,
    required this.icon,
    required this.color,
    required this.status,
  });

  factory MoneyJar.fromRawJson(String str) =>
      MoneyJar.fromJson(jsonDecode(str));

  factory MoneyJar.fromJson(Map<String, dynamic> json) => MoneyJar(
        id: json["id"],
        name: json["name"],
        balance: json["balance"] is int
            ? (json["balance"] as int).toDouble()
            : json["balance"],
        icon: json["icon"],
        color: json["color"],
        status: json["status"]
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'balance': balance,
        'icon': icon,
        'color': color,
        'status': status,
      };
}
