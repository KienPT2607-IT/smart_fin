import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/loan.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/loan_detail_screen.dart';

class LoanHistoryCard extends StatefulWidget {
  final Loan loan;
  const LoanHistoryCard({super.key, required this.loan});

  @override
  State<LoanHistoryCard> createState() => _LoanHistoryCardState();
}

class _LoanHistoryCardState extends State<LoanHistoryCard> {
  late MoneyJar _jar;
  late bool isDataFetch;

  @override
  void initState() {
    super.initState();
    isDataFetch = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isDataFetch) {
      _jar = Provider.of<MoneyJarProvider>(context)
          .getJarById(widget.loan.moneyJar);
      isDataFetch = true;
    }
  }

  String _getLoanAmount() {
    String amount = widget.loan.amount.truncateToDouble() == widget.loan.amount
        ? '${widget.loan.amount.truncate()}'
        : '${widget.loan.jarBalance}';
    if (widget.loan.isCreatorLender) return "-$amount";
    return "+$amount";
  }

  // String _getFriendName() {
  //   String name = Provider.of<FriendProvider>(context)
  //       .getFriendName(widget.loan.participantId);
  //   return name;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(
        CupertinoPageRoute(
          builder: (context) => LoanDetailScreen(
            loanId: widget.loan.id,
          ),
        ),
      )
          .then((value) {
        setState(() {});
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: widget.loan.isRepaid
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
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
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            _jar.name,
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
                            widget.loan.participantName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
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
                      _getLoanAmount(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: widget.loan.isCreatorLender
                            ? Colors.black
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      widget.loan.jarBalance.truncateToDouble() ==
                              widget.loan.jarBalance
                          ? '${widget.loan.jarBalance.truncate()}'
                          : '${widget.loan.jarBalance}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(10),
                    Text(DateFormat('dd/MM/yyyy').format(widget.loan.createAt)),
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
