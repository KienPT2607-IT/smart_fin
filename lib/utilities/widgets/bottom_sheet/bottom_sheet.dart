import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/screens/add_friend_screen.dart';
import 'package:smart_fin/screens/add_income_source_screen.dart';
import 'package:smart_fin/screens/add_money_jar_screen.dart';

String _getBottomSheetTitle(int sectionType) {
  if (sectionType == 0) {
    return "Money Jars";
  }
  if (sectionType == 1) {
    return "Friends";
  }
  if (sectionType == 2) {
    return "Income Sources";
  }
  return "";
}

void _getInputScreen(BuildContext context, int sectionType) {
  if (sectionType == 0) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const AddMoneyJarScreen(),
      ),
    );
  } else if (sectionType == 1) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const AddFriendScreen(),
      ),
    );
  } else if (sectionType == 2) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AddIncomeSourceScreen(),
      ),
    );
  }
}

void showCustomBottomSheet(BuildContext context, int sectionType, List cards,
    Function onItemSelected) {
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
              Text(
                _getBottomSheetTitle(sectionType),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => _getInputScreen(context, sectionType),
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
              itemCount: cards.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onItemSelected(index);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: cards[index],
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
