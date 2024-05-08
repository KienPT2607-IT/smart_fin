import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/friend.dart';
import 'package:smart_fin/data/services/apis/friend_services.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/screens/edit_friend_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/cards/friend_infor_card.dart';

class ViewFriendScreen extends StatefulWidget {
  const ViewFriendScreen({super.key});

  @override
  State<ViewFriendScreen> createState() => _ViewFriendScreenState();
}

class _ViewFriendScreenState extends State<ViewFriendScreen> {
  late List<FriendInforCard> _friendInforList;
  late FriendService _friendService;
  @override
  void initState() {
    super.initState();
    _friendInforList = [];
    _friendService = FriendService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _friendInforList = Provider.of<FriendProvider>(context)
        .friendList
        .map((each) => FriendInforCard(friend: each))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My friends"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: _friendInforList.length,
          separatorBuilder: (context, index) => const Gap(10),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => EditFriendScreen(
                              id: _friendInforList[index].friend.id),
                        ),
                      ),
                      child: _friendInforList[index],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: _getAction(_friendInforList[index].friend),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconButton _getAction(Friend jar) {
    return IconButton(
      onPressed: () => _showDeleteConfirmDialog(
        jar.id,
      ),
      icon: const Icon(
        IconlyLight.delete,
        color: Colors.red,
      ),
    );
  }

  void _showDeleteConfirmDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete confirmation!"),
          content: const Text("Are you sure to remove this friendship!"),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleDeleteFriend(id),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _handleDeleteFriend(String id) async {
    bool result = await _friendService.removeFriend(context: context, id: id);
    if (mounted && result) {
      showCustomSnackBar(
        context,
        "Friend removed!",
        Constant.contentTypes["success"]!,
      );
      Navigator.of(context).pop();
    }
  }
}
