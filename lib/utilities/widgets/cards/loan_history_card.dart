import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
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
      _jar =
          Provider.of<MoneyJarProvider>(context).getJar(widget.loan.moneyJar);
      isDataFetch = true;
    }
  }

  String _getLoanAmount() {
    double amount = widget.loan.amount;
    if (widget.loan.isCreatorLender) return "-$amount";
    return "+$amount";
  }

  String _getFriendName() {
    String name = Provider.of<FriendProvider>(context)
        .getFriendName(widget.loan.participantId);
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const LoanDetailScreen(),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              //TODO: add this color to theme
              color:
                  widget.loan.isRepaid ? const Color(0xff21CE99) : Colors.grey,
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
                            _getFriendName(),
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
                        fontSize: 14,
                        color: widget.loan.isCreatorLender
                            ? Colors.black
                            : const Color(0xff21CE99),
                      ),
                    ),
                    Text(
                      "${widget.loan.jarBalance}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // const Gap(5),
            // Container(
            //   constraints: BoxConstraints(
            //     maxWidth: MediaQuery.of(context).size.width * 0.8,
            //   ),
            //   padding: const EdgeInsets.all(5),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: const Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: <Widget>[
            //       Icon(IconlyLight.wallet, size: 16),
            //       Gap(10),
            //       Flexible(
            //         child: Text(
            //           "This is the category card",
            //           overflow: TextOverflow.ellipsis,
            //           style: TextStyle(
            //             fontWeight: FontWeight.w400,
            //             fontSize: 14,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
