import 'package:flutter/cupertino.dart';
import 'package:smart_fin/data/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    // id: "",
    username: "",
    email: "",
    fullName: "",
    token: "",
    // TODO: add more newly added fields
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromRawJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void updateInfor(){
    notifyListeners();
  }
}
