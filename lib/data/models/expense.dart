import 'dart:convert';

class Expense {
  String id;
  double amount;
  DateTime createAt;
  String note;
  String moneyJar;
  double jarBalance;
  String category;

  Expense({
    required this.id,
    required this.amount,
    required this.createAt,
    required this.note,
    required this.moneyJar,
    required this.jarBalance,
    required this.category,
  });

  factory Expense.fromRawJson(String str) => Expense.fromJson(jsonDecode(str));

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"] ?? "",
        amount: json["amount"] is int
            ? (json["amount"] as int).toDouble()
            : json["amount"],
        createAt: DateTime.parse(json["create_at"]),
        note: json["note"] ?? "",
        moneyJar: json["money_jar"] ?? "",
        jarBalance: json["jar_balance"] is int
            ? (json["jar_balance"] as int).toDouble()
            : json["jar_balance"],
        category: json["category"] ?? "",
      );

  String toRawJson() => jsonEncode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "create_at": createAt.toIso8601String(),
        "note": note,
        "money_jar": moneyJar,
        "category": category,
      };
}
