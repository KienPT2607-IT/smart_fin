import 'package:flutter/material.dart';
import 'package:smart_fin/data/models/friend.dart';

class FriendSelectionCard extends StatelessWidget {
  final Friend friend;
  const FriendSelectionCard({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 165),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD5D5D7),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(friend.name),
                Text(friend.phoneNumber ?? ""),
                Text(friend.email ?? ""),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
