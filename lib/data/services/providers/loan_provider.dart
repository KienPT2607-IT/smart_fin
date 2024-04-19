import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/loan.dart';

class LoanProvider extends ChangeNotifier {
  late List<Loan> _loanList;

  LoanProvider() {
    _loanList = [];
  }

  List<Loan> get loanList => _loanList;

  void setLoans(String rawJson) {
    List jsonList = jsonDecode(rawJson)["data"];
    for (var json in jsonList) {
      _loanList.add(Loan.fromJson(json));
    }
    notifyListeners();
  }

  void addLoan(Loan loan) {
    _loanList.insert(0, loan);
    notifyListeners();
  }

  void removeLoan(String id) {
    int index = _loanList.indexWhere((loan) => loan.id == id);

    if (index != -1) {
      _loanList.removeAt(index);
      notifyListeners();
    }
  }

  void update(Loan updatedLoan) {
    int index = _loanList.indexWhere((loan) => loan.id == updatedLoan.id);

    if (index != -1) {
      _loanList[index] = updatedLoan;
    }
    notifyListeners();
  }

  double getLendTotal() {
    double total = 0;
    for (var each in _loanList) {
      if (each.isCreatorLender) {
        total += each.amount;
      }
    }
    return total;
  }

  double getBorrowTotal() {
    double total = 0;
    for (var each in _loanList) {
      if (!each.isCreatorLender) {
        total += each.amount;
      }
    }
    return total;
  }
}
