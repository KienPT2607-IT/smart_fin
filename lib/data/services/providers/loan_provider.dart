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

  void removeAll() {
    _loanList = [];
  }

  void addLoan(Loan loan) {
    _loanList.insert(0, loan);
    notifyListeners();
  }

  void removeLoan(String loanId) {
    int index = _loanList.indexWhere((loan) => loan.id == loanId);

    if (index != -1) {
      _loanList.removeAt(index);
      notifyListeners();
    }
  }

  void updateLoanNote(String loanId, String newNote) {
    int index = _loanList.indexWhere((loan) => loan.id == loanId);

    if (index != -1) {
      _loanList[index].note = newNote;
      notifyListeners();
    }
  }

  void updateRepaidStatus(String loanId) {
    int index = _loanList.indexWhere((loan) => loan.id == loanId);

    if (index != -1) {
      _loanList[index].isRepaid = !_loanList[index].isRepaid;
      notifyListeners();
    }
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

  double getLendTotalByJar(String jarId) {
    double total = 0;
    for (var each in _loanList) {
      if (each.moneyJar == jarId && each.isCreatorLender) {
        total += each.amount;
      }
    }
    return total;
  }

  double getBorrowTotalByJar(String jarId) {
    double total = 0;
    for (var each in _loanList) {
      if (each.moneyJar == jarId && !each.isCreatorLender) {
        total += each.amount;
      }
    }
    return total;
  }

  Loan getLoanById(String loanId) {
    int index = _loanList.indexWhere((each) => each.id == loanId);
    return _loanList[index];
  }
}
