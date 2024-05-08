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
        _moneyJarList.insert(0, MoneyJar.fromJson(json));
      } else {
        _moneyJarList.add(MoneyJar.fromJson(json));
      }
    }
    notifyListeners();
  }

  void removeAll() {
    _moneyJarList = [];
  }

  void addJar(MoneyJar jar) {
    _moneyJarList.insert(0, jar);
    notifyListeners();
  }

  void removeJar(String id) {
    _moneyJarList.removeWhere((jar) => jar.id == id);
    notifyListeners();
  }

  void updateJar({
    required String id,
    required String newName,
    required String newIcon,
    required int newColor,
  }) {
    var index = _moneyJarList.indexWhere((jar) => jar.id == id);
    if (index != -1) {
      _moneyJarList[index].name = newName;
      _moneyJarList[index].icon = newIcon;
      _moneyJarList[index].color = newColor;
      notifyListeners();
    }
  }

  void updateBalance({
    required String id,
    required double amount,
    required bool isIncreased,
  }) {
    var index = _moneyJarList.indexWhere((jar) => jar.id == id);
    if (index != -1) {
      if (isIncreased) {
        _moneyJarList[index].balance += amount;
      } else {
        _moneyJarList[index].balance -= amount;
      }
      notifyListeners();
    }
  }

  void changeJarStatus(String id) {
    var index = _moneyJarList.indexWhere((jar) => jar.id == id);
    if (index != -1) {
      MoneyJar jar = _moneyJarList.removeAt(index);
      jar.status = !jar.status;
      if (jar.status) {
        _moneyJarList.insert(0, jar);
      } else {
        _moneyJarList.add(jar);
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
