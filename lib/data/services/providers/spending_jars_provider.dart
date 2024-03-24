import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/models/spending_jar.dart';

class SpendingJarsProvider extends ChangeNotifier {
  List<SpendingJar> _spendingJarList = [];

  List<SpendingJar> get spendingJarList => _spendingJarList;

  void setSpendingJars(List<SpendingJar> spendingJars) {
    _spendingJarList = spendingJars;
    notifyListeners();
  }

  void addSpendingJar(SpendingJar spendingJar) {
    _spendingJarList.add(spendingJar);
    notifyListeners();
  }

  void removeSpendingJar(String id) {
    _spendingJarList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateSpendingJar(SpendingJar updatedJar) {
    var index =
        _spendingJarList.indexWhere((element) => element.id == updatedJar.id);

    if (index != -1) {
      _spendingJarList[index] = updatedJar;
      notifyListeners();
    }
  }
}
