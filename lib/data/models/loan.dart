import 'dart:convert';

class Loan {
  String id;
  String lenderId;
  String borrowerId;
  double amount;
  String note;
  bool isRepaid;
  String creatorRole; //Lender/Borrower
  String creatorId;
  DateTime createAt;

  Loan({
    required this.id,
    required this.lenderId,
    required this.borrowerId,
    required this.amount,
    required this.note,
    required this.isRepaid,
    required this.creatorRole,
    required this.creatorId,
    required this.createAt,
  });

  factory Loan.fromRawJson(String str) => Loan.fromJson(jsonDecode(str));

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"],
        lenderId: json["lender_id"],
        borrowerId: json["borrower_id"],
        amount: json["amount"] is int
            ? (json["amount"] as int).toDouble()
            : json["amount"],
        note: json["note"],
        isRepaid: json["is_repaid"],
        creatorRole: json["creator_role"],
        creatorId: json["creator_id"],
        createAt: json["create_at"],
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
    "id": id,
    "lender_id": lenderId,
    "borrower_id": borrowerId,
    "amount": amount,
    "note": note,
    "is_repaid": isRepaid,
    "creator_role": creatorRole,
    "creator_id": creatorId,
    "create_at": createAt.toIso8601String(),
  };
}
