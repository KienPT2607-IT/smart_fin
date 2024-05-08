import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:smart_fin/data/models/money_jar.dart';

class MoneyJarCard extends StatelessWidget {
  final MoneyJar moneyJar;
  const MoneyJarCard({super.key, required this.moneyJar});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: moneyJar.status ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD5D5D7),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  moneyJar.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(10),
                Text(
                  moneyJar.balance.truncateToDouble() == moneyJar.balance
                      ? '${moneyJar.balance.truncate()}'
                      : '${moneyJar.balance}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          SvgPicture.asset(
            moneyJar.icon,
            color: Color(moneyJar.color),
          ),
        ],
      ),
    );
  }
}
