import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:smart_fin/data/models/money_jar.dart';

class IncomeSourceCard extends StatelessWidget {
  final MoneyJar moneyJar;
  const IncomeSourceCard({super.key, required this.moneyJar});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    moneyJar.balance.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.,
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
      ),
    );
  }
}
