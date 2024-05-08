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
      if (json["status"]) {
        _categoryList.insert(0, category.Category.fromJson(json));
      } else {
        _categoryList.add(category.Category.fromJson(json));
      }
    }
    notifyListeners();
  }

  void removeAll() {
    _categoryList = [];
  }

  void addCategory(category.Category category) {
    _categoryList.insert(0, category);
    notifyListeners();
  }

  void updateCategoryDetail({
    required String id,
    required String newName,
    required String newIcon,
    required int newColor,
  }) {
    int index = _categoryList.indexWhere((each) => each.id == id);
    if (index != -1) {
      _categoryList[index].name = newName;
      _categoryList[index].icon = newIcon;
      _categoryList[index].color = newColor;
      notifyListeners();
    }
  }

  void updateCategoryStatus(String id){
    int index = _categoryList.indexWhere((each) => each.id == id);
    if (index != -1) {
      category.Category current = _categoryList.removeAt(index);
      current.status = !current.status;
      if (current.status) {
        _categoryList.insert(0, current);
      } else {
        _categoryList.add(current);
      }
      notifyListeners();
    }
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
            status: true,
          );
  }
}
