import 'dart:convert';

class Category {
  String id;
  String name;
  String icon;
  int color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(jsonDecode(str));

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        color: json["color"],
      );

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        'icon': icon,
        'color': color,
      };
}
