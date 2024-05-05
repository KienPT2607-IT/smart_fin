import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/income.dart';
import 'package:smart_fin/data/models/income_source.dart';
import 'package:smart_fin/data/models/money_jar.dart';
import 'package:smart_fin/data/services/apis/income_note_services.dart';
import 'package:smart_fin/data/services/providers/income_provider.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/init_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/customs/custom_divider.dart';

class IncomeDetailScreen extends StatefulWidget {
  final String incomeId;
  const IncomeDetailScreen({super.key, required this.incomeId});

  @override
  State<IncomeDetailScreen> createState() => _IncomeDetailScreenState();
}

class _IncomeDetailScreenState extends State<IncomeDetailScreen> {
  late Income _income;
  late IncomeSource _incomeSource;
  late MoneyJar _moneyJar;
  late IncomeNoteService _incomeNoteService;
  late TextEditingController _noteCtrl;

  late bool _isDataFetched;

  @override
  void initState() {
    super.initState();
    _incomeNoteService = IncomeNoteService();
    _noteCtrl = TextEditingController();
    _isDataFetched = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _income = Provider.of<IncomeProvider>(context, listen: false)
          .getIncomeById(widget.incomeId);
      _moneyJar = Provider.of<MoneyJarProvider>(context, listen: false)
          .getJarById(_income.moneyJar);
      _incomeSource = Provider.of<IncomeSourceProvider>(context, listen: false)
          .getSourceById(_income.incomeSource);
      _noteCtrl.text = _income.note;
      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income detail"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(32),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
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
                                "Income",
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
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat("dd/MM/yyyy HH:mm")
                                        .format(_income.createAt),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    "+${_income.amount}",
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
                                  _customCard(
                                    _incomeSource.name,
                                    _incomeSource.icon,
                                    _incomeSource.color,
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
                                  _customTitle("TO"),
                                  const Gap(10),
                                  _customCard(
                                    _moneyJar.name,
                                    _moneyJar.icon,
                                    _moneyJar.color,
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
                                  _customTitle("NOTE"),
                                  const Gap(10),
                                  Flexible(
                                    child: Text(_income.note),
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

  void _deleteIncome() async {
    bool result = await _incomeNoteService.deleteIncome(
      context: context,
      incomeId: widget.incomeId,
    );
    if (mounted && result) {
      showCustomSnackBar(
          context, "Income removed!", Constant.contentTypes["success"]!);
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

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete confirmation"),
          content: const Text("Are you sure to delete this income note!"),
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
                    onPressed: () => _deleteIncome(),
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

  void _updateExpenseNote() {
    _incomeNoteService.updateNote(
      context: context,
      incomeId: widget.incomeId,
      note: _noteCtrl.text,
    );
    Navigator.of(context).pop();
  }

  void _showEditNoteDialog() {
    _noteCtrl.text = _income.note;
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

  Container _customCard(String name, String icon, int color) {
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
          color: Color(color),
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            icon,
            width: 24,
            color: Color(color),
          ),
          const Gap(10),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 150,
            ),
            child: Text(
              name,
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
}
