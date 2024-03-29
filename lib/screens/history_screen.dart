import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/expense.dart';
import 'package:smart_fin/utilities/widgets/expense_history_card.dart';

class HistoryScreen extends StatefulWidget {
  Function(int destination) onSelected;

  HistoryScreen({super.key, required this.onSelected});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late int _selectedSegment;

  // List<String> items = List<String>.generate(10000, (i) => 'Item $i');
  List<ExpenseHistoryCard> items = [
    ExpenseHistoryCard(
      expense: Expense(
        id: "1",
        amount: 200,
        jarBalance: 800,
        moneyJar: "2",
        image: "Jar 2",
        note: "Note 2",
        createAt: DateTime.now(),
        category: 'Fuel',
      ),
    ),
    ExpenseHistoryCard(
      expense: Expense(
        id: "2",
        amount: 200,
        jarBalance: 800,
        moneyJar: "2",
        image: "Jar 2",
        note: "Note 2",
        createAt: DateTime.now(),
        category: 'Food',
      ),
    ),
    ExpenseHistoryCard(
      expense: Expense(
        id: "3",
        amount: 300,
        jarBalance: 500,
        moneyJar: "3",
        image: "Jar 3",
        note: "Note 3",
        createAt: DateTime.now(),
        category: 'Transport',
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _selectedSegment = 0;
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
                          // TODO: Style this text
                          style: TextStyle(color: Colors.white),
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
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index];
            },
          ),
        )
      ],
    );
  }
}
