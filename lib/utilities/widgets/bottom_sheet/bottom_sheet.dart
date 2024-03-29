import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/screens/add_money_jar_screen.dart';

void showCustomBottomSheet(BuildContext context, List cards) {
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
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(IconlyLight.close_square),
                ),
                const Text(
                  "Money Jars",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.filter),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Jars"),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const AddMoneyJarScreen(),
                      ),
                    ),
                    icon: SvgPicture.asset("assets/icons/apps/add.svg"),
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: ListView.separated(
              itemCount: cards.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: cards[index],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
