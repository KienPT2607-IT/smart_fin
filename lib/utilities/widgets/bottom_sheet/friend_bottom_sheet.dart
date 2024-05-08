import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/screens/add_friend_screen.dart';
import 'package:smart_fin/utilities/widgets/cards/friend_infor_card.dart';

void showFriendBottomSheet({
  required BuildContext context,
  required Function(int) onFriendSelected,
}) {
  const String title = "Categories";
  var friendInforList = Provider.of<FriendProvider>(context, listen: false)
      .friendList
      .map((each) => FriendInforCard(friend: each))
      .toList();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 5,
            width: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(IconlyLight.close_square),
              ),
              const Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => _getInputScreen(context),
                icon: SvgPicture.asset("assets/icons/app/add.svg"),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          const Gap(10),
          Expanded(
            child: ListView.separated(
              itemCount: friendInforList.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onFriendSelected(index);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: friendInforList[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

void _getInputScreen(BuildContext context) => Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AddFriendScreen(),
      ),
    );
