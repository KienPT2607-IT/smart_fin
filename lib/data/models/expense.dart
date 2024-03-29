import 'dart:convert';

class Expense {
  String id;
  double amount;
  DateTime createAt;
  String note;
  String image;
  String moneyJar;
  double jarBalance;
  String category;

  Expense({
    required this.id,
    required this.amount,
    required this.createAt,
    required this.note,
    required this.image,
    required this.moneyJar,
    required this.jarBalance,
    required this.category,
  });

  factory Expense.fromRawJson(String str) => Expense.fromJson(json.decode(str));

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"] ?? "",
        amount: json["amount"] ?? 0.0,
        createAt: DateTime.parse(json["create_at"]),
        note: json["note"] ?? "",
        image: json["image"] ?? "",
        moneyJar: json["money_jar"] ?? "",
        jarBalance: json["jar_balance"] ?? 0.0,
        category: json["category"] ?? "",
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "create_at": createAt.toIso8601String(),
        "note": note,
        "image": image,
        "money_jar": moneyJar,
        "category": category,
      };
}
