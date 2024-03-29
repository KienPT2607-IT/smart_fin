import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/models/money_jar.dart';

class MoneyJarProvider extends ChangeNotifier {
  List<MoneyJar> _moneyJarList = [];

  List<MoneyJar> get moneyJarList => _moneyJarList;

  void setJars(List<MoneyJar> moneyJars) {
    _moneyJarList = moneyJars;
    notifyListeners();
  }

  void addJar(MoneyJar moneyJars) {
    _moneyJarList.add(moneyJars);
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
}
