import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fin/data/models/money_jar.dart';

class MoneyJarProvider extends ChangeNotifier {
  late List<MoneyJar> _moneyJarList;

  MoneyJarProvider() {
    _moneyJarList = [];
  }

  List<MoneyJar> get moneyJarList => _moneyJarList;

  void setJars(String jarsRawJson) {
    List jarList = jsonDecode(jarsRawJson)["data"];
    for (var jar in jarList) {
      _moneyJarList.add(MoneyJar(
        id: jar["id"],
        name: jar["name"],
        balance: jar["balance"] is int
            ? (jar["balance"] as int).toDouble()
            : jar["balance"],
        icon: jar["icon"],
        color: jar["color"],
      ));
    }
    notifyListeners();
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

  void updateBalance({required String id, required double amount}) {
    var index = _moneyJarList.indexWhere((jar) => jar.id == id);

    if (index != -1) {
      _moneyJarList[index].balance -= amount;
      notifyListeners();
    }
  }

  double getBalance(String jarId) {
    int index = _moneyJarList.indexWhere((jar) => jar.id == jarId);
    return (index != -1) ? _moneyJarList[index].balance : 0;
  }

  String getName(String jarId) {
    int index = _moneyJarList.indexWhere((jar) => jar.id == jarId);
    return (index != -1) ? _moneyJarList[index].name : "No name";
  }

  MoneyJar getJar(String jarId) {
    int index = _moneyJarList.indexWhere((jar) => jar.id == jarId);
    return (index != -1) ? _moneyJarList[index] : MoneyJar(
      id: "",
      name: "No name",
      balance: 0,
      icon: "assets/icons/apps/document_error.svg",
      color: 0xffe5e5e5,
    );
  }
}
