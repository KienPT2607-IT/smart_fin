import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/category.dart' as category;
import 'package:smart_fin/utilities/constants/constants.dart';

class CategoryProvider extends ChangeNotifier {
  late List<category.Category> _categoryList;

  CategoryProvider() {
    _categoryList = [];
  }
  List<category.Category> get categoryList => _categoryList;

  void setCategories(String rawJson) {
    List categoryJsonList = jsonDecode(rawJson)["data"];
    for (var json in categoryJsonList) {
      _categoryList.add(category.Category.fromJson(json));
    }
    notifyListeners();
  }

  void addCategory(category.Category category) {
    _categoryList.add(category);
    notifyListeners();
  }

  category.Category getCategoryById(String id) {
    int index = -1;
    index = _categoryList.indexWhere((element) => element.id == id);
    return (index >= 0)
        ? _categoryList[index]
        : category.Category(
            id: id,
            name: "None",
            icon: "",
            color: Constant.defaultNonePropertyColor,
          );
  }
}
