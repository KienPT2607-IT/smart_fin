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

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late int _selectedSegment;
  late int _selectedLoanType;
  late bool _isDataFetched;

  late double _normalRadius;
  // late double _selectedRadius;

  late List<MoneyJar> _jarList;
  late List<IncomeSource> _sourceList;
  late List<TotalExpenseByJarCard> _totalExpByJarCardList;
  late List<TotalIncomeBySourceCard> _totalIncBySourceList;
  @override
  void initState() {
    super.initState();
    _selectedSegment = 0;
    _selectedLoanType = 0;
    _isDataFetched = false;

    _normalRadius = 50;
    // _selectedRadius = 60;

    _totalExpByJarCardList = [];
    _totalIncBySourceList = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _jarList = Provider.of<MoneyJarProvider>(context).moneyJarList;
      _sourceList = Provider.of<IncomeSourceProvider>(context).incomeSourceList;
    }
  }

  List<PieChartSectionData> _showStatistics() {
    if (_selectedSegment == 0) {
      return showExpenseChart();
    } else if (_selectedSegment == 1) {
      return showLoanChart();
    } else {
      return showIncomeChart();
    }
  }

  List<PieChartSectionData> showExpenseChart() {
    var expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    double totalExpense = expenseProvider.getTotalExpense();
    return List.generate(
      _jarList.length,
      (index) {
        double value = expenseProvider.getTotalExpenseByJarId(
          _jarList[index].id,
        );
        double percentage = totalExpense != 0 ? value / totalExpense * 100 : 0;
        if (value > 0) {
          _totalExpByJarCardList.add(TotalExpenseByJarCard(
            moneyJar: _jarList[index],
            percentage: percentage,
            total: value,
          ));
        }
        return PieChartSectionData(
          value: value,
          title: _jarList[index].name,
          color: Color(_jarList[index].color),
          radius: _normalRadius,
          badgeWidget: Text("${percentage.toStringAsFixed(1)}%"),
          badgePositionPercentageOffset: -0.5,
        );
      },
    );
  }

  List<PieChartSectionData> showLoanChart() {
    var loanProvider = Provider.of<LoanProvider>(context, listen: false);
    double totalLoan = (_selectedLoanType == 0)
        ? loanProvider.getLendTotal()
        : loanProvider.getBorrowTotal();
    // return List.generate(
    //   2,
    //   (index) {
    //     double value = value;
    //     double percentage = totalLoan != 0 ? value / totalLoan * 100 : 0;
    //     return PieChartSectionData(
    //       title: _jarList[index].name,
    //       color: Color(_jarList[index].color),
    //       radius: _normalRadius,
    //       badgeWidget: Text("${percentage.toStringAsFixed(1)}%"),
    //       badgePositionPercentageOffset: -0.5,
    //     );
    //   },
    // );
    return [];
  }

  List<PieChartSectionData> showIncomeChart() {
    var incomeProvider = Provider.of<IncomeProvider>(context, listen: false);
    double totalIncome = incomeProvider.getTotalIncome();
    return List.generate(
      _sourceList.length,
      (index) {
        double value = incomeProvider.getTotalIncomeBySourceId(
          _sourceList[index].id,
        );
        double percentage = totalIncome != 0 ? value / totalIncome * 100 : 0;
        if (value > 0) {
          _totalIncBySourceList.add(TotalIncomeBySourceCard(
            incomeSource: _sourceList[index],
            percentage: percentage,
            total: value,
          ));
        }
        return PieChartSectionData(
          value: value,
          title: _sourceList[index].name,
          color: Color(_sourceList[index].color),
          radius: _normalRadius,
          badgeWidget: Text("${percentage.toStringAsFixed(1)}%"),
          badgePositionPercentageOffset: -0.5,
        );
      },
    );
  }

  Widget _showTotalList() {
    switch (_selectedSegment) {
      case 0:
        return ListView.builder(
          itemCount: _totalExpByJarCardList.length,
          itemBuilder: (context, index) => _totalExpByJarCardList[index],
        );
      // case 1:
      //   break;
      case 2:
        return ListView.builder(
          itemCount: _totalIncBySourceList.length,
          itemBuilder: (context, index) => _totalIncBySourceList[index],
        );
      default:
        return Container();
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
              0: Text("Expense"),
              1: Text("Loan"),
              2: Text("Income"),
            },
            groupValue: _selectedSegment,
            onValueChanged: (newValue) => setState(() {
              _selectedSegment = newValue!;
              _totalExpByJarCardList = [];
              _totalIncBySourceList = [];
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
          // TODO: Consider this to implement for the three all segments
          (_selectedSegment == 1)
              ? CupertinoSlidingSegmentedControl(
                  children: const {
                    0: Text("Lend"),
                    1: Text("Borrow"),
                  },
                  groupValue: _selectedLoanType,
                  onValueChanged: (newValue) => setState(() {
                    _selectedLoanType = newValue!;
                  }),
                )
              : Container(),
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
