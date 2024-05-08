import 'dart:convert';

class IncomeSource {
  String id;
  String name;
  String icon;
  int color;
  bool status;

  IncomeSource({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.status,
  });

  factory IncomeSource.fromRawJson(String str) =>
      IncomeSource.fromJson(jsonDecode(str));

  factory IncomeSource.fromJson(Map<String, dynamic> json) => IncomeSource(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        color: json['color'],
        status: json['status'],
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
        'status': status,
      };
}
