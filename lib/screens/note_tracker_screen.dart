import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/spending_jar.dart';
import 'package:smart_fin/data/models/user.dart';
import 'package:smart_fin/data/services/providers/spending_jars_provider.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/Income_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/expense_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/loan_section.dart';
import 'package:smart_fin/utilities/widgets/spending_jar_card.dart';
import 'package:smart_fin/utilities/customs/custom_date_picker.dart';

class NoteTrackerScreen extends StatefulWidget {
  const NoteTrackerScreen({super.key});

  @override
  State<NoteTrackerScreen> createState() => _NoteTrackerScreenState();
}

class _NoteTrackerScreenState extends State<NoteTrackerScreen> {
  late User user;
  late List<SpendingJarCard> spendingJarCardList;
  late int selectedForm;

  late GlobalKey<FormState> _formKey;
  late TextEditingController _moneyAmountCtrl;
  late TextEditingController _noteCtrl;
  late TextEditingController _dobCtrl;
  late DateTime date;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _moneyAmountCtrl = TextEditingController();
    _noteCtrl = TextEditingController();
    _dobCtrl = TextEditingController();
    _dobCtrl.text = DateTime.now().toString().split(" ")[0];
    selectedForm = 0;
    date = DateTime.now();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context, listen: true).user;
    spendingJarCardList =
        Provider.of<SpendingJarsProvider>(context, listen: true)
            .spendingJarList
            .map((spendingJar) => SpendingJarCard(spendingJar: spendingJar))
            .toList();
  }

  void _saveNote() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          CupertinoSlidingSegmentedControl(
            children: const {
              0: Text("Expense"),
              1: Text("Loan"),
              2: Text("Income"),
            },
            groupValue: selectedForm,
            onValueChanged: (newValue) => setState(() {
              selectedForm = newValue!;
            }),
          ),
          const Gap(10),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: SizedBox(
                      height: 155,
                      child: (selectedForm == 0)
                          ? ExpenseSection(
                              spendingJarList: spendingJarCardList,
                              onSelected: (value) {
                                // setState(() {}); //TODO: Do something here
                              })
                          : (selectedForm == 1)
                              ? LoanSection(
                                  onSelected: (value) {
                                    setState(() {});
                                  },
                                )
                              : IncomeSection(
                                  onSelected: (value) {
                                    setState(() {});
                                  },
                                ),
                    ),
                  ),
                ),
                const Gap(10),
                TextFormField(
                  controller: _moneyAmountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    prefixIcon: const Icon(IconlyLight.wallet),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                const Gap(10),
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () => showDatePickerDialog(
                    context,
                    CupertinoDatePicker(
                      initialDateTime: date,
                      mode: CupertinoDatePickerMode.date,
                      maximumDate: DateTime.now(),
                      minimumYear: DateTime.now().year - 100,
                      onDateTimeChanged: (newDate) {
                        setState(() {
                          date = newDate;
                          _dobCtrl.text = date.toString().split(" ")[0];
                        });
                      },
                    ),
                  ),
                ),
                const Gap(10),
                TextFormField(
                  controller: _noteCtrl,
                  decoration: InputDecoration(
                    labelText: "Note",
                    prefixIcon: const Icon(IconlyLight.document),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Gap(170),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _saveNote();
                      },
                      style: ElevatedButton.styleFrom(
                        // TODO: use theme
                        backgroundColor: const Color(0xFF563D81),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Note",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
