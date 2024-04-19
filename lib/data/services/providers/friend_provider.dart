import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_fin/data/models/friend.dart';

class FriendProvider extends ChangeNotifier {
  late List<Friend> _friendList;

  FriendProvider() {
    _friendList = [];
  }

  List<Friend> get friendList => _friendList;

  void setFriends(String rawJson) {
    List jsonList = jsonDecode(rawJson)["data"];
    for (var json in jsonList) {
      // TODO: implement add with alphabetical order
      _friendList.add(Friend.fromJson(json));
      notifyListeners();
    }
  }

  Friend getFriend(String id) {
    int index = _friendList.indexWhere((friend) => friend.id == id);
    return (index != -1)
        ? _friendList[index]
        : Friend(
            id: "",
            name: "",
            phoneNumber: "",
            email: "",
          );
  }

  String getFriendName(String id) {
    int index = _friendList.indexWhere((friend) => friend.id == id);
    return (index != -1) ? _friendList[index].name : "";
  }

  void addFriend(Friend newFriend) {
    _friendList.add(newFriend);
    notifyListeners();
  }

  void updateFriend(Friend updatedFriend) {
    int index =
        _friendList.indexWhere((element) => element.id == updatedFriend.id);

    if (index != -1) {
      _friendList[index] = updatedFriend;
      notifyListeners();
    }
  }

  void unfriend(Friend removedFriend) {
    int index =
        _friendList.indexWhere((element) => element.id == removedFriend.id);

    if (index != -1) {
      _friendList.removeAt(index);
      notifyListeners();
    }
  }
}
