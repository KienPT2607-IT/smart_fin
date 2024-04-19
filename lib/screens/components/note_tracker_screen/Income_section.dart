// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/utilities/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:smart_fin/utilities/widgets/cards/income_source_card.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

class IncomeSection extends StatefulWidget {
  final List<MoneyJarCard> moneyJarCardList;
  final List<IncomeSourceCard> incomeCardList;
  final int sectionType;
  final Function(String value) onIncomeSourceSelected;
  final Function(String value) onMoneyJarSelected;
  const IncomeSection({
    super.key,
    required this.moneyJarCardList,
    required this.incomeCardList,
    required this.sectionType,
    required this.onIncomeSourceSelected,
    required this.onMoneyJarSelected,
  });

  @override
  State<IncomeSection> createState() => _IncomeSectionState();
}

class _IncomeSectionState extends State<IncomeSection> {
  late int _selectedJarIndex;
  late int _selectedSourceIndex;

  @override
  void initState() {
    super.initState();
    _selectedJarIndex = -1;
    _selectedSourceIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Source",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showCustomBottomSheet(
                      context,
                      widget.sectionType,
                      widget.incomeCardList,
                      (index) => setState(() {
                        _selectedSourceIndex = index;
                        widget.onIncomeSourceSelected(
                          widget.incomeCardList[index].incomeSource.id,
                        );
                      }),
                    ),
                    icon: const Icon(IconlyLight.category),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  child: (_selectedSourceIndex != -1)
                      ? widget.incomeCardList[_selectedSourceIndex]
                      : Container(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Jar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () => showCustomBottomSheet(
                      context,
                      widget.sectionType - 2,
                      widget.moneyJarCardList,
                      (index) => setState(() {
                        _selectedJarIndex = index;
                        widget.onMoneyJarSelected(
                          widget.moneyJarCardList[index].moneyJar.id,
                        );
                      }),
                    ),
                    icon: const Icon(IconlyLight.category),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  child: (_selectedJarIndex != -1)
                      ? widget.moneyJarCardList[_selectedJarIndex]
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
