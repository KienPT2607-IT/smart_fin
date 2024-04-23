import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/expense_provider.dart';
import 'package:smart_fin/data/services/providers/income_provider.dart';
import 'package:smart_fin/data/services/providers/loan_provider.dart';
import 'package:smart_fin/utilities/widgets/cards/expense_history_card.dart';
import 'package:smart_fin/utilities/widgets/cards/income_history_card.dart';
import 'package:smart_fin/utilities/widgets/cards/loan_history_card.dart';

class HistoryScreen extends StatefulWidget {
  final Function(int destination) onSelected;

  const HistoryScreen({super.key, required this.onSelected});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late int _selectedSegment;
  late bool _isDataFetched;

  late List<ExpenseHistoryCard> _expHistoryCardList;
  late List<LoanHistoryCard> _loanHistoryCardList;
  late List<IncomeHistoryCard> _incomeHistoryCardList;
  @override
  void initState() {
    super.initState();
    _isDataFetched = false;
    _selectedSegment = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _expHistoryCardList = Provider.of<ExpenseProvider>(context, listen: false)
          .expenseList
          .map((expense) => ExpenseHistoryCard(expense: expense))
          .toList();
      _loanHistoryCardList = Provider.of<LoanProvider>(context, listen: false)
          .loanList
          .map((loan) => LoanHistoryCard(loan: loan))
          .toList();
      _incomeHistoryCardList =
          Provider.of<IncomeProvider>(context, listen: false)
              .incomeList
              .map((income) => IncomeHistoryCard(income: income))
              .toList();
      _isDataFetched = true;
    }
  }

  ListView _showHistory() {
    switch (_selectedSegment) {
      case 0:
        return _showExpenseHistory();
      case 1:
        return _showLoanHistory();
      case 2:
        return _showIncomeHistory();
      default:
        return ListView();
    }
  }

  ListView _showExpenseHistory() => ListView.builder(
        itemCount: _expHistoryCardList.length,
        itemBuilder: (context, index) => _expHistoryCardList[index],
      );

  ListView _showLoanHistory() => ListView.builder(
        itemCount: _loanHistoryCardList.length,
        itemBuilder: (context, index) => _loanHistoryCardList[index],
      );

  ListView _showIncomeHistory() => ListView.builder(
        itemCount: _incomeHistoryCardList.length,
        itemBuilder: (context, index) => _incomeHistoryCardList[index],
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Gap(2),
        CupertinoSlidingSegmentedControl(
          children: const {
            0: Text("Expense"),
            1: Text("Loan"),
            2: Text("Income"),
          },
          groupValue: _selectedSegment,
          onValueChanged: (value) => setState(() => _selectedSegment = value!),
        ),
        const Gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => widget.onSelected(2),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
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
          child: _showHistory(),
        ),
      ],
    );
  }
}
