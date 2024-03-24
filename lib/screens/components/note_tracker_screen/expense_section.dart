import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/spending_jar.dart';
import 'package:smart_fin/utilities/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:smart_fin/utilities/widgets/spending_jar_card.dart';

class ExpenseSection extends StatefulWidget {
  List<SpendingJarCard> spendingJarList;
  Function(String value) onSelected;
  ExpenseSection({
    super.key,
    required this.spendingJarList,
    required this.onSelected,
  });

  @override
  State<ExpenseSection> createState() => _ExpenseSectionState();
}

class _ExpenseSectionState extends State<ExpenseSection> {
  late int selectedCardIndex;

  @override
  void initState() {
    super.initState();

    selectedCardIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: 95),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Spending Jars",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () {
                  showCustomBottomSheet(context, widget.spendingJarList);
                },
                icon: const Icon(IconlyLight.category),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: widget.spendingJarList.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  widget.onSelected(
                      widget.spendingJarList[index].spendingJar.id!);
                  setState(() {
                    selectedCardIndex = index;
                  });
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: selectedCardIndex == index
                          ? Border.all(
                              color: const Color(0xFF21CE99),
                              width: 1.2,
                            )
                          : null,
                    ),
                    child: widget.spendingJarList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
