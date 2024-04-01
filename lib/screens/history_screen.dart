import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/expense.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/providers/expense_provider.dart';
import 'package:smart_fin/utilities/widgets/expense_history_card.dart';

class HistoryScreen extends StatefulWidget {
  final Function(int destination) onSelected;

  const HistoryScreen({super.key, required this.onSelected});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedSegment = 0;
  late bool _isDataFetched;

  late List<ExpenseHistoryCard> _expHistoryCardList;
  @override
  void initState() {
    super.initState();
    _isDataFetched = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _expHistoryCardList = Provider.of<ExpenseProvider>(context, listen: true)
          .expenseList
          .map((expense) => ExpenseHistoryCard(expense: expense))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoSlidingSegmentedControl(
          children: const {
            0: Text("Expense"),
            1: Text("Loan"),
            2: Text("Income"),
          },
          groupValue: _selectedSegment,
          onValueChanged: (value) => setState(() => _selectedSegment = value!),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => widget.onSelected(2),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff4766DF),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          IconlyLight.graph,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Views statistics",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const Icon(
                        IconlyLight.arrow_right_2,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(10),
        Expanded(
          child: ListView.builder(
            itemCount: _selectedSegment == 0
                ? _expHistoryCardList.length
                : (_selectedSegment == 1)
                    ? _expHistoryCardList.length
                    : _expHistoryCardList.length,
            itemBuilder: (context, index) {
              if (_selectedSegment == 0) {
                return _expHistoryCardList[index];
              } else if (_selectedSegment == 1) {
                return _expHistoryCardList[index];
              } else {
                return _expHistoryCardList[index];
              }
            },
          ),
        ),
      ],
    );
  }
}
