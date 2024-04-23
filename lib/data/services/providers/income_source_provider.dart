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

  String getName(String id) {
    int index = _incomeSourceList.indexWhere((source) => source.id == id);
    return (index != -1) ? _incomeSourceList[index].name : "";
  }

  IncomeSource getSource(String id) {
    int index = _incomeSourceList.indexWhere((source) => source.id == id);
    return (index != -1)
        ? _incomeSourceList[index]
        : IncomeSource(
            id: "",
            name: "No name",
            icon: "assets/icons/app/document_error.svg",
            color: Constant.defaultNonePropertyColor,
          );
  }
}
