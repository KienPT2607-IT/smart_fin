import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/expense.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/apis/expense_note_services.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/expense_detail_screen.dart';
import 'package:smart_fin/utilities/widgets/bottom_sheet/category_bottom_sheet.dart';
import 'package:smart_fin/utilities/widgets/cards/category_card.dart';

class ExpenseHistoryCard extends StatefulWidget {
  final Expense expense;
  const ExpenseHistoryCard({super.key, required this.expense});

  @override
  State<ExpenseHistoryCard> createState() => _ExpenseHistoryCardState();
}

class _ExpenseHistoryCardState extends State<ExpenseHistoryCard> {
  late bool _isDataFetched;
  late MoneyJar _jar;
  late CategoryCard _categoryCard;
  late ExpenseNoteService _expenseNoteService;

  @override
  void initState() {
    super.initState();
    _isDataFetched = false;
    _expenseNoteService = ExpenseNoteService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isDataFetched) {
      _jar = Provider.of<MoneyJarProvider>(context)
          .getJarById(widget.expense.moneyJar);
      _categoryCard = CategoryCard(Provider.of<CategoryProvider>(context)
          .getCategoryById(widget.expense.category));
      _isDataFetched = true;
    }
  }

  void _updateExpenseCategory(CategoryCard card) {
    _expenseNoteService.updateCategory(
      context: context,
      expenseId: widget.expense.id,
      categoryId: card.category.id,
    );
    setState(() {
      _categoryCard = card;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ExpenseDetailScreen(
            expenseId: widget.expense.id,
            onCategoryCardChange: (value) => setState(() {
              _categoryCard = value;
            }),
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
                          color: Color(_jar.color),
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
                            widget.expense.note,
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
            GestureDetector(
              onTap: () => showCategoryBottomSheet(
                context: context,
                onCategorySelected: (value) => _updateExpenseCategory(value),
              ),
              child: _categoryCard,
            ),
          ],
        ),
      ),
    );
  }
}
