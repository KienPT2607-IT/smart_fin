import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/money_jar.dart';

class TotalLoanByJarCard extends StatelessWidget {
  final MoneyJar moneyJar;
  final double percentage;
  final double total;
  const TotalLoanByJarCard({
    super.key,
    required this.moneyJar,
    required this.percentage,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 55,
                decoration: BoxDecoration(
                  color: Color(moneyJar.color),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text("${percentage.toStringAsFixed(1)}%")),
              ),
              const Gap(5),
              Text(moneyJar.name),
            ],
          ),
          Row(
            children: <Widget>[
              Text("$total"),
              IconButton(
                onPressed: () {},
                icon: const Icon(IconlyLight.arrow_right_2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
