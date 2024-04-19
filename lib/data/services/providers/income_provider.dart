import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/income.dart';

class IncomeProvider extends ChangeNotifier {
  late List<Income> _incomeList;

  IncomeProvider() {
    _incomeList = [];
  }

  List<Income> get incomeList => _incomeList;

  void setIncomes(String rawJson) {
    List jsonList = jsonDecode(rawJson)["data"];
    for (var json in jsonList) {
      _incomeList.add(Income.fromJson(json));
    }
    notifyListeners();
  }

  void addIncome(Income income) {
    _incomeList.insert(0, income);
    notifyListeners();
  }

  void updateIncome(Income updatedIncome) {
    int index =
        _incomeList.indexWhere((income) => income.id == updatedIncome.id);

    if (index != -1) {
      _incomeList[index];
      notifyListeners();
    }
  }

  void removeIncome(String id) {
    int index = _incomeList.indexWhere((income) => income.id == id);

    if (index != -1) {
      _incomeList.removeAt(index);
      notifyListeners();
    }
  }

  double getTotalIncome() {
    double total = 0;
    for (var each in _incomeList) {
      total += each.amount;
    }
    return total;
  }

  double getTotalIncomeBySourceId(String sourceId) {
    double total = 0;
    for (var each in _incomeList) {
      if (each.incomeSource == sourceId) total += each.amount;
    }
    return total;
  }
}
