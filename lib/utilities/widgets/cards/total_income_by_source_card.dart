import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/income_source.dart';

class TotalIncomeBySourceCard extends StatelessWidget {
  final IncomeSource incomeSource;
  final double percentage;
  final double total;
  const TotalIncomeBySourceCard({
    super.key,
    required this.incomeSource,
    required this.percentage,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 55,
                decoration: BoxDecoration(
                  color: Color(incomeSource.color),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text("${percentage.toStringAsFixed(1)}%")),
              ),
              const Gap(5),
              Text(incomeSource.name),
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
