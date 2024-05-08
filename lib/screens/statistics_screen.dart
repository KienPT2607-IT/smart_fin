import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/providers/expense_provider.dart';
import 'package:smart_fin/data/services/providers/income_provider.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/data/services/providers/loan_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/utilities/widgets/cards/total_expense_by_jar_card.dart';
import 'package:smart_fin/utilities/widgets/cards/total_income_by_source_card.dart';
import 'package:smart_fin/utilities/widgets/cards/total_loan_by_jar_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late int _selectedSegment;
  late int _selectedSubSegment;
  late bool _isDataFetched;
  late double _totalExpense;
  late double _totalIncome;
  late double _totalLend;
  late double _totalBorrow;

  late double _normalRadius;
  // late double _selectedRadius;

  late List<MoneyJar> _jarList;
  late List<IncomeSource> _sourceList;
  late List<TotalExpenseByJarCard> _totalExpByJarCardList;
  late List<TotalIncomeBySourceCard> _totalIncBySourceList;
  late List<TotalLoanByJarCard> _totalLoanByJarCardList;

  @override
  void initState() {
    super.initState();
    _selectedSegment = 0;
    _selectedSubSegment = 0;
    _totalExpense = 0;
    _totalIncome = 0;
    _totalLend = 0;
    _totalBorrow = 0;

    _normalRadius = 50;
    // _selectedRadius = 60;

    _totalExpByJarCardList = [];
    _totalIncBySourceList = [];
    _totalLoanByJarCardList = [];
    _isDataFetched = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _jarList = Provider.of<MoneyJarProvider>(context).moneyJarList;
      _sourceList = Provider.of<IncomeSourceProvider>(context).incomeSourceList;

      _totalExpense = Provider.of<ExpenseProvider>(context).getTotalExpense();
      _totalIncome = Provider.of<IncomeProvider>(context).getTotalIncome();
      _totalLend = Provider.of<LoanProvider>(context).getLendTotal();
      _totalBorrow = Provider.of<LoanProvider>(context).getBorrowTotal();
    }
  }

  List<PieChartSectionData> _showStatistics() {
    if (_selectedSegment == 0) {
      if (_selectedSubSegment == 0) {
        return _showExpenseChart();
      } else {
        return _showIncomeChart();
      }
    } else {
      return _showLoanChart();
    }
  }

  List<PieChartSectionData> _showExpenseChart() {
    return List.generate(
      _jarList.length,
      (index) {
        double value = Provider.of<ExpenseProvider>(context, listen: false)
            .getTotalExpenseByJarId(_jarList[index].id);
        double percentage =
            _totalExpense != 0 ? value / _totalExpense * 100 : 0;
        if (value > 0) {
          _totalExpByJarCardList.add(TotalExpenseByJarCard(
            moneyJar: _jarList[index],
            percentage: percentage,
            total: value,
          ));
        }
        return PieChartSectionData(
          value: value,
          title: (percentage > 2) ? _jarList[index].name : "",
          color: Color(_jarList[index].color),
          radius: _normalRadius,
          badgeWidget:
              Text((percentage > 2) ? "${percentage.toStringAsFixed(1)}%" : ""),
          badgePositionPercentageOffset: -0.5,
        );
      },
    );
  }

  List<PieChartSectionData> _showIncomeChart() {
    return List.generate(
      _sourceList.length,
      (index) {
        double value = Provider.of<IncomeProvider>(context, listen: false)
            .getTotalIncomeBySourceId(
          _sourceList[index].id,
        );
        double percentage = _totalIncome != 0 ? value / _totalIncome * 100 : 0;
        if (value > 0) {
          _totalIncBySourceList.add(TotalIncomeBySourceCard(
            incomeSource: _sourceList[index],
            percentage: percentage,
            total: value,
          ));
        }
        return PieChartSectionData(
          value: value,
          title: (percentage > 2) ? _sourceList[index].name : "",
          color: Color(_sourceList[index].color),
          radius: _normalRadius,
          badgeWidget:
              Text((percentage > 2) ? "${percentage.toStringAsFixed(1)}%" : ""),
          badgePositionPercentageOffset: -0.5,
        );
      },
    );
  }

  List<PieChartSectionData> _showLoanChart() {
    var loanProvider = Provider.of<LoanProvider>(context, listen: false);
    double totalLoan = (_selectedSubSegment == 0) ? _totalLend : _totalBorrow;
    return List.generate(
      _jarList.length,
      (index) {
        double value = (_selectedSubSegment == 0)
            ? loanProvider.getLendTotalByJar(_jarList[index].id)
            : loanProvider.getBorrowTotalByJar(_jarList[index].id);
        double percentage = totalLoan != 0 ? value / totalLoan * 100 : 0;
        if (value > 0) {
          _totalLoanByJarCardList.add(TotalLoanByJarCard(
            moneyJar: _jarList[index],
            percentage: percentage,
            total: value,
          ));
        }
        return PieChartSectionData(
          value: value,
          title: (percentage > 2) ? _jarList[index].name : "",
          color: Color(_jarList[index].color),
          radius: _normalRadius,
          badgeWidget:
              Text((percentage > 2) ? "${percentage.toStringAsFixed(1)}%" : ""),
          badgePositionPercentageOffset: -0.5,
        );
      },
    );
  }

  Widget _showTotalList() {
    switch (_selectedSegment) {
      case 0:
        if (_selectedSubSegment == 0) {
          return ListView.builder(
            itemCount: _totalExpByJarCardList.length,
            itemBuilder: (context, index) => _totalExpByJarCardList[index],
          );
        } else {
          return ListView.builder(
            itemCount: _totalIncBySourceList.length,
            itemBuilder: (context, index) => _totalIncBySourceList[index],
          );
        }
      case 1:
        return ListView.builder(
          itemCount: _totalLoanByJarCardList.length,
          itemBuilder: (context, index) => _totalLoanByJarCardList[index],
        );
      case 2:
      default:
        return Container();
    }
  }

  Widget showSubSegments() {
    if (_selectedSegment == 0) {
      return CupertinoSlidingSegmentedControl(
        children: {
          0: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Expense",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _totalExpense.truncateToDouble() == _totalExpense
                      ? '${_totalExpense.truncate()}'
                      : '$_totalExpense',
                ),
              ],
            ),
          ),
          1: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Income",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _totalIncome.truncateToDouble() == _totalIncome
                      ? '${_totalIncome.truncate()}'
                      : '$_totalIncome',
                ),
              ],
            ),
          ),
        },
        groupValue: _selectedSubSegment,
        onValueChanged: (newValue) => setState(() {
          _selectedSubSegment = newValue!;
          _totalExpByJarCardList = [];
          _totalIncBySourceList = [];
        }),
      );
    } else {
      return CupertinoSlidingSegmentedControl(
        children: {
          0: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Lend",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _totalLend.truncateToDouble() == _totalLend
                      ? '${_totalLend.truncate()}'
                      : '$_totalLend',
                ),
              ],
            ),
          ),
          1: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Borrow",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _totalBorrow.truncateToDouble() == _totalBorrow
                      ? '${_totalBorrow.truncate()}'
                      : '$_totalBorrow',
                ),
              ],
            ),
          ),
        },
        groupValue: _selectedSubSegment,
        onValueChanged: (newValue) => setState(() {
          _selectedSubSegment = newValue!;
          _totalLoanByJarCardList = [];
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          const Gap(2),
          CupertinoSlidingSegmentedControl(
            children: const {
              0: Text("Expense & Income"),
              1: Text("Loan"),
            },
            groupValue: _selectedSegment,
            onValueChanged: (newValue) => setState(() {
              _selectedSegment = newValue!;
              _selectedSubSegment = 0;
              _totalExpByJarCardList = [];
              _totalIncBySourceList = [];
              _totalLoanByJarCardList = [];
            }),
          ),
          const Gap(16),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: double.infinity,
                sections: _showStatistics(),
              ),
            ),
          ),
          const Gap(10),
          showSubSegments(),
          const Gap(10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFD5D5D7),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: _showTotalList(),
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
