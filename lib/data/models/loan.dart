import 'dart:convert';

class Loan {
  String id;
  String participantId;
  String participantName;
  double amount;
  String note;
  bool isRepaid;
  bool isCreatorLender;
  DateTime createAt;
  String moneyJar;
  double jarBalance;

  Loan({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.amount,
    required this.note,
    required this.isRepaid,
    required this.isCreatorLender,
    required this.createAt,
    required this.moneyJar,
    required this.jarBalance,
  });

  factory Loan.fromRawJson(String str) => Loan.fromJson(jsonDecode(str));

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"],
        participantId: json["participant_id"],
        participantName: json["participant_name"],
        amount: json["amount"] is int
            ? (json["amount"] as int).toDouble()
            : json["amount"],
        note: json["note"] ?? "",
        isRepaid: json["is_repaid"],
        isCreatorLender: json["is_creator_lender"],
        createAt: DateTime.parse(json["create_at"]),
        moneyJar: json["money_jar"],
        jarBalance: json["jar_balance"] is int
            ? (json["jar_balance"] as int).toDouble()
            : json["jar_balance"],
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "participant_id": participantId,
        "participant_name": participantName,
        "amount": amount,
        "note": note,
        "is_repaid": isRepaid,
        "is_creator_lender": isCreatorLender,
        "create_at": createAt.toIso8601String(),
        "money_jar": moneyJar,
      };
}
