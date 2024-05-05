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
      _incomeSourceList.add(IncomeSource.fromJson(json));
    }
    notifyListeners();
  }

  void removeAll() {
    _incomeSourceList = [];
  }

  void addSource(IncomeSource source) {
    _incomeSourceList.add(source);
    notifyListeners();
  }

  void updateSource(IncomeSource incomeSource) {
    notifyListeners();
  }

  void removeSource() {
    notifyListeners();
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
