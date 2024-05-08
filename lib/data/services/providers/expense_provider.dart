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

  void removeAll() {
    _expenseList = [];
  }

  void addExpense(Expense expense) {
    _expenseList.add(expense);
    _expenseList.sort((a, b) => b.createAt.compareTo(a.createAt));
    notifyListeners();
  }

  void removeExpenseById(String id) {
    _expenseList.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  void updateExpenseNote(String expenseId, String newNote) {
    int index = _expenseList.indexWhere((each) => each.id == expenseId);

    if (index != -1) {
      _expenseList[index].note = newNote;
      notifyListeners();
    }
  }

  void updateExpenseCategory(String expenseId, String categoryId) {
    int index = _expenseList.indexWhere((expense) => expense.id == expenseId);
    if (index != -1) {
      _expenseList[index].category = categoryId;
      notifyListeners();
    }
  }

  double getTotalExpenseByJarId(String moneyJarId) {
    double total = 0;
    for (var each in _expenseList) {
      if (each.moneyJar == moneyJarId) {
        total += each.amount;
      }
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

  Expense getExpenseById(String expenseId) {
    int index = _expenseList.indexWhere((each) => each.id == expenseId);
    return _expenseList[index];
  }
}
