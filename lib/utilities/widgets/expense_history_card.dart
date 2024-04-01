import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/expense.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/expense_detail_screen.dart';

class ExpenseHistoryCard extends StatefulWidget {
  final Expense expense;
  const ExpenseHistoryCard({super.key, required this.expense});

  @override
  State<ExpenseHistoryCard> createState() => _ExpenseHistoryCardState();
}

class _ExpenseHistoryCardState extends State<ExpenseHistoryCard> {
  late MoneyJar _jar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _jar = Provider.of<MoneyJarProvider>(context, listen: false)
        .getJar(widget.expense.moneyJar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => const ExpenseDetailScreen(),
      )),
      child: Container(
        padding: const EdgeInsets.all(10),
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
                          color: Color(_jar.color),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SvgPicture.asset(
                        _jar.icon,
                        color: Color(_jar.color),
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        _jar.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "-${widget.expense.amount}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${widget.expense.jarBalance}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(5),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    IconlyLight.wallet,
                    size: 16,
                  ),
                  Gap(10),
                  Flexible(
                    child: Text(
                      "This is the category card",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
