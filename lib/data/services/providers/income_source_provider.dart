import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/utilities/constants/constants.dart';

class IncomeSourceProvider extends ChangeNotifier {
  late List<IncomeSource> _incomeSourceList;

  IncomeSourceProvider() {
    _incomeSourceList = [];
  }

  List<IncomeSource> get incomeSourceList => _incomeSourceList;

  void setSources(String sourcesRawJson) {
    List sourceJsonList = jsonDecode(sourcesRawJson)["data"];
    for (var json in sourceJsonList) {
      if (json["status"]) {
        _incomeSourceList.insert(0, IncomeSource.fromJson(json));
      } else {
        _incomeSourceList.add(IncomeSource.fromJson(json));
      }
    }
    notifyListeners();
  }

  void removeAll() {
    _incomeSourceList = [];
  }

  void addSource(IncomeSource source) {
    _incomeSourceList.insert(0, source);
    notifyListeners();
  }

  void updateSourceDetail({
    required String id,
    required String newName,
    required String newIcon,
    required int newColor,
  }) {
    int index = _incomeSourceList.indexWhere((element) => element.id == id);
    if (index != -1) {
      _incomeSourceList[index].name = newName;
      _incomeSourceList[index].icon = newIcon;
      _incomeSourceList[index].color = newColor;
      notifyListeners();
    }
  }

  void updateSourceStatus(String id) {
    int index = _incomeSourceList.indexWhere((element) => element.id == id);
    if (index != -1) {
      IncomeSource source = _incomeSourceList.removeAt(index);
      source.status = !source.status;
      if (source.status) {
        _incomeSourceList.insert(0, source);
      } else {
        _incomeSourceList.add(source);
      }
      notifyListeners();
    }
  }

  String getSourceNameById(String sourceId) {
    int index = _incomeSourceList.indexWhere((source) => source.id == sourceId);
    return _incomeSourceList[index].name;
  }

  IncomeSource getSourceById(String sourceId) {
    int index = _incomeSourceList.indexWhere((source) => source.id == sourceId);
    return _incomeSourceList[index];
  }
}
