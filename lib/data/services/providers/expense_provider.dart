import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  late List<Expense> _expenseList;

  ExpenseProvider() {
    _expenseList = [];
  }

  List<Expense> get expenseList => _expenseList;

  void setExpenses(String expensesRawJson) {
    List expenseList = jsonDecode(expensesRawJson)["data"];
    for (var expense in expenseList) {
      _expenseList.insert(
        0,
        Expense(
          id: expense["id"],
          amount: expense["amount"] is int
              ? (expense["amount"] as int).toDouble()
              : expense["amount"],
          createAt: DateTime.parse(expense["create_at"]),
          note: expense["note"] ?? "",
          image: expense["image"] ?? "",
          moneyJar: expense["money_jar"],
          jarBalance: expense["jar_balance"] is int
              ? (expense["jar_balance"] as int).toDouble()
              : expense["jar_balance"],
          category: expense["category"] ?? "",
        ),
      );
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
    var index =
        _expenseList.indexWhere((expense) => expense.id == updatedExpense.id);

    if (index != -1) {
      _expenseList[index] = updatedExpense;
      notifyListeners();
    }
  }
}
