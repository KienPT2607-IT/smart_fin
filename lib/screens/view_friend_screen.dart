import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/utilities/widgets/cards/friend_infor_card.dart';

class ViewFriendScreen extends StatefulWidget {
  const ViewFriendScreen({super.key});

  @override
  State<ViewFriendScreen> createState() => _ViewFriendScreenState();
}

class _ViewFriendScreenState extends State<ViewFriendScreen> {
  late List<FriendInforCard> _friendInforList;

  @override
  void initState() {
    super.initState();
    _friendInforList = [];
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
        child: Expanded(
          child: ListView.separated(
            itemCount: _friendInforList.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _friendInforList[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
