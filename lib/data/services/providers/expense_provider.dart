import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  late List<Expense> _expenseList;

  ExpenseProvider() {
    _expenseList = [];
  }

  List<Expense> get expenseList => _expenseList;

  void setExpenses(String rawJson) {
    List jsonList = jsonDecode(rawJson)["data"];
    for (var json in jsonList) {
      _expenseList.add(Expense.fromJson(json));
    }
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenseList.insert(0, expense);
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenseList.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  void updateExpense(Expense updatedExpense) {
    int index =
        _expenseList.indexWhere((expense) => expense.id == updatedExpense.id);

    if (index != -1) {
      _expenseList[index] = updatedExpense;
      notifyListeners();
    }
  }

  double getTotalExpenseByJarId(String moneyJarId) {
    double total = 0;
    for (var each in _expenseList) {
      if (each.moneyJar == moneyJarId) total += each.amount;
    }
    return total;
  }

  double getTotalExpense() {
    double total = 0;
    for (var each in _expenseList) {
      total += each.amount;
    }
    return total;
  }
}
