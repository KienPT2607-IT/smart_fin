import 'dart:convert';

class Income {
  String id;
  double amount;
  DateTime createAt;
  String note;
  String moneyJar;
  double jarBalance;
  String incomeSource;

  Income({
    required this.id,
    required this.amount,
    required this.createAt,
    required this.note,
    required this.moneyJar,
    required this.jarBalance,
    required this.incomeSource,
  });

  factory Income.fromRawJson(String str) => Income.fromJson(jsonDecode(str));

  factory Income.fromJson(Map<String, dynamic> json) => Income(
        id: json["id"],
        amount: (json["amount"] is int)
            ? (json["amount"] as int).toDouble()
            : json["amount"],
        createAt: DateTime.parse(json["create_at"]),
        note: json["note"] ?? "",
        moneyJar: json["money_jar"],
        jarBalance: (json["jar_balance"] is int)
            ? (json["jar_balance"] as int).toDouble()
            : json["jar_balance"],
        incomeSource: json["income_source"],
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "create_at": createAt.toIso8601String(),
        "note": note,
        "money_jar": moneyJar,
        "jar_balance": jarBalance,
        "income_source": incomeSource,
      };
}
