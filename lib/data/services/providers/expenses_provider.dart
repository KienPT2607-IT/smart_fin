import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/models/expense.dart';

class ExpensesProvider extends ChangeNotifier {
  List<Expense> _expenseList = [];

  List<Expense> get expenseList => _expenseList;

  void setExpenses(List<Expense> expenses) {
    _expenseList = expenses;
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
