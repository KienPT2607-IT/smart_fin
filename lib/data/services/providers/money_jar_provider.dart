import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/money_jar.dart';

class MoneyJarProvider extends ChangeNotifier {
  late List<MoneyJar> _moneyJarList;

  MoneyJarProvider() {
    _moneyJarList = [];
  }

  List<MoneyJar> get moneyJarList => _moneyJarList;

  void setJars(String rawJson) {
    List jarJsonList = jsonDecode(rawJson)["data"];
    for (var json in jarJsonList) {
      if (json["status"]) {
        _moneyJarList.add(MoneyJar.fromJson(json));
      } else {
        _moneyJarList.insert(_moneyJarList.length - 1, MoneyJar.fromJson(json));
      }
    }
    notifyListeners();
  }

  void removeAll() {
    _moneyJarList = [];
  }

  void addJar(MoneyJar jar) {
    _moneyJarList.add(jar);
    notifyListeners();
  }

  void removeJar(String id) {
    _moneyJarList.removeWhere((jar) => jar.id == id);
    notifyListeners();
  }

  void updateJar(MoneyJar updatedJar) {
    var index = _moneyJarList.indexWhere((jar) => jar.id == updatedJar.id);

    if (index != -1) {
      _moneyJarList[index] = updatedJar;
      notifyListeners();
    }
  }

  void updateBalance({
    required String jarId,
    required double amount,
    required bool isIncreased,
  }) {
    var index = _moneyJarList.indexWhere((jar) => jar.id == jarId);

    if (index != -1) {
      if (isIncreased) {
        _moneyJarList[index].balance += amount;
      } else {
        _moneyJarList[index].balance -= amount;
      }
      notifyListeners();
    }
  }

  double getBalance(String jarId) {
    int index = _moneyJarList.indexWhere((jar) => jar.id == jarId);
    return (index != -1) ? _moneyJarList[index].balance : 0;
  }

  String getName(String jarId) {
    int index = _moneyJarList.indexWhere((jar) => jar.id == jarId);
    return (index != -1) ? _moneyJarList[index].name : "";
  }

  MoneyJar getJarById(String jarId) {
    int index = _moneyJarList.indexWhere((jar) => jar.id == jarId);
    return _moneyJarList[index];
  }
}
