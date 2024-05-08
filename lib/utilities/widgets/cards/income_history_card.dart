import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/income.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/income_detail_screen.dart';

class IncomeHistoryCard extends StatefulWidget {
  final Income income;
  const IncomeHistoryCard({super.key, required this.income});

  @override
  State<IncomeHistoryCard> createState() => _IncomeHistoryCardState();
}

class _IncomeHistoryCardState extends State<IncomeHistoryCard> {
  late IncomeSource _source;
  late MoneyJar _jar;
  late bool _isDataFetch;

  @override
  void initState() {
    super.initState();
    _isDataFetch = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetch) {
      _source = Provider.of<IncomeSourceProvider>(context)
          .getSourceById(widget.income.incomeSource);
      _jar = Provider.of<MoneyJarProvider>(context)
          .getJarById(widget.income.moneyJar);
      _isDataFetch = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IncomeDetailScreen(
            incomeId: widget.income.id,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(_source.color),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SvgPicture.asset(
                        _source.icon,
                        color: Color(_source.color),
                      ),
                    ),
                    const Gap(10),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            _source.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            _jar.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      widget.income.amount.truncateToDouble() ==
                              widget.income.amount
                          ? '+${widget.income.amount.truncate()}'
                          : '+${widget.income.amount}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      widget.income.jarBalance.truncateToDouble() ==
                              widget.income.jarBalance
                          ? '${widget.income.jarBalance.truncate()}'
                          : '${widget.income.jarBalance}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(10),
                    Text(DateFormat('dd/MM/yyyy')
                        .format(widget.income.createAt)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
