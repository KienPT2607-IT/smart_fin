import 'dart:convert';

class Category {
  String id;
  String name;
  String icon;
  int color;
  bool status;
  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.status,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(jsonDecode(str));

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        color: json["color"],
        status: json["status"],
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "color": color,
        "status": status,
      };
}
