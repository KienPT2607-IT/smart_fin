import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    username: "",
    email: "",
    fullName: "",
    token: "",
    // TODO: add more newly added fields
  );

  User get user => _user;

  String getToken() {
    return _user.token;
  }

  void setUser(String userRawJson) {
    _user = User.fromRawJson(userRawJson);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void updateInfor() {
    // TODO: Implement when profile sreen implemented
    notifyListeners();
  }
}
