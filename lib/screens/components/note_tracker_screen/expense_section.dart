import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/utilities/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

class ExpenseSection extends StatefulWidget {
  final int sectionType;
  final List<MoneyJarCard> jarCardList;
  final Function(String value) onJarSelected;
  const ExpenseSection({
    super.key,
    required this.sectionType,
    required this.jarCardList,
    required this.onJarSelected,
  });

  @override
  State<ExpenseSection> createState() => _ExpenseSectionState();
}

class _ExpenseSectionState extends State<ExpenseSection> {
  late int _selectedJar;

  @override
  void initState() {
    super.initState();

    _selectedJar = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Money Jars",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            IconButton(
              onPressed: () {
                showCustomBottomSheet(
                  context,
                  widget.sectionType,
                  widget.jarCardList,
                  (index) {
                    setState(() {
                      _selectedJar = index;
                    });
                  },
                );
              },
              icon: const Icon(IconlyLight.category),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.jarCardList.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                widget.onJarSelected(widget.jarCardList[index].moneyJar.id);
                setState(() {
                  _selectedJar = index;
                });
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: _selectedJar == index
                        ? Border.all(
                            color: const Color(0xFF21CE99),
                            width: 1.2,
                          )
                        : null,
                  ),
                  child: widget.jarCardList[index]),
            ),
          ),
        ),
      ],
    );
  }
}
