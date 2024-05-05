import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/expense.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/apis/expense_note_services.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/data/services/providers/expense_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/init_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/bottom_sheet/category_bottom_sheet.dart';
import 'package:smart_fin/utilities/widgets/cards/category_card.dart';
import 'package:smart_fin/utilities/widgets/customs/custom_divider.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final String expenseId;
  final Function(CategoryCard) onCategoryCardChange;
  const ExpenseDetailScreen({
    super.key,
    required this.expenseId,
    required this.onCategoryCardChange,
  });

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  late CategoryCard _categoryCard;
  late Expense _expense;
  late MoneyJar _moneyJar;
  late ExpenseNoteService _expenseNoteService;
  late TextEditingController _noteCtrl;

  late bool _isDataFetched;
  @override
  void initState() {
    super.initState();
    _isDataFetched = false;
    _expenseNoteService = ExpenseNoteService();
    _noteCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _expense = Provider.of<ExpenseProvider>(context)
          .getExpenseById(widget.expenseId);
      _categoryCard = CategoryCard(Provider.of<CategoryProvider>(context)
          .getCategoryById(_expense.category));
      _moneyJar = Provider.of<MoneyJarProvider>(context, listen: false)
          .getJarById(_expense.moneyJar);
      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense detail"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFD5D5D7),
                        blurRadius: 16,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Constant.defaultRegularIcons["check"]!,
                              color: Colors.white,
                              width: 16,
                            ),
                            const Gap(10),
                            const Center(
                              child: Text(
                                "Expense",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat("dd/MM/yyyy HH:mm")
                                        .format(_expense.createAt),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "${_expense.amount}",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const CustomDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  _customTitle("FROM"),
                                  const Gap(10),
                                  _customJarCard(),
                                ],
                              ),
                            ),
                            const CustomDivider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  _customTitle("NOTE"),
                                  const Gap(10),
                                  Flexible(
                                    child: Text(_expense.note),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => showCategoryBottomSheet(
                        context: context,
                        onCategorySelected: (value) => {
                          _updateExpenseCategory(value),
                          widget.onCategoryCardChange(value),
                        },
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                    Constant.defaultLightIcons["tag"]!),
                                const Gap(20),
                                const Text("Edit category"),
                              ],
                            ),
                            _categoryCard,
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showEditNoteDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                Constant.defaultLightIcons["edit"]!),
                            const Gap(20),
                            const Text("Edit note"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Back"),
                      ),
                    ),
                    const Gap(32),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showDeleteConfirmDialog(),
                        child: const Text("Remove"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateExpenseCategory(CategoryCard selectedCard) {
    _expenseNoteService.updateCategory(
      context: context,
      expenseId: _expense.id,
      categoryId: selectedCard.category.id,
    );
    setState(() {
      _categoryCard = selectedCard;
    });
  }

  void _updateExpenseNote() {
    _expenseNoteService.updateNote(
      context: context,
      expenseId: _expense.id,
      note: _noteCtrl.text,
    );
    // showCustomSnackBar(context, "New note updated");
    Navigator.of(context).pop();
  }

  void _deleteExpense() async {
    await _expenseNoteService.deleteExpense(
        context: context, expenseId: _expense.id);
    if (mounted) {
      showCustomSnackBar(
          context, "Expense removed!", Constant.contentTypes["success"]!);
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => const InitScreen(
              startScreen: 1,
              isFirstInit: false,
            ),
          ),
          (route) => false);
    }
  }

  SizedBox _customTitle(String title) {
    return SizedBox(
      width: 50,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Container _customJarCard() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(_moneyJar.color),
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            _moneyJar.icon,
            width: 24,
            color: Color(_moneyJar.color),
          ),
          const Gap(10),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 150,
            ),
            child: Text(
              _moneyJar.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog() {
    _noteCtrl.text = _expense.note;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit note"),
          content: TextFormField(
            autofocus: true,
            minLines: 1,
            maxLines: 4,
            // initialValue: _expense.note,
            controller: _noteCtrl,
            decoration: const InputDecoration(hintText: "Note"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () => _updateExpenseNote(),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete confirmation"),
          content: const Text("Are you sure to delete this expense note!"),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _deleteExpense(),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
