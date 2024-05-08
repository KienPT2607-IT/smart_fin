import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/add_money_jar_screen.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

void showMoneyJarBottomSheet({
  required BuildContext context,
  required Function(int) onMoneyJarSelected,
}) {
  const String title = "Money Jars";
  var jarCardList = Provider.of<MoneyJarProvider>(context, listen: false)
      .moneyJarList
      .map((each) => MoneyJarCard(moneyJar: each))
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
        children: [
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
              itemCount: jarCardList.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (jarCardList[index].moneyJar.status) {
                      onMoneyJarSelected(index);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: jarCardList[index],
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
        builder: (context) => const AddMoneyJarScreen(),
      ),
    );
