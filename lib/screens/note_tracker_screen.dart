import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/controllers/note_tracker_controller.dart';
import 'package:smart_fin/data/services/apis/expense_note_services.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/Income_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/expense_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/loan_section.dart';
import 'package:smart_fin/utilities/widgets/friend_card.dart';
import 'package:smart_fin/utilities/widgets/money_jar_card.dart';
import 'package:smart_fin/utilities/customs/custom_date_picker.dart';

class NoteTrackerScreen extends StatefulWidget {
  const NoteTrackerScreen({super.key});

  @override
  State<NoteTrackerScreen> createState() => _NoteTrackerScreenState();
}

class _NoteTrackerScreenState extends State<NoteTrackerScreen> {
  late int _selectedNoteType;
  //TODO: give this a meaingful name, this is id of the money jar or income source
  late String _id;

  late List<MoneyJarCard> _moneyJarCardList;
  late List<FriendCard> _friendCardList;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _amountCtrl;
  late TextEditingController _noteCtrl;
  late TextEditingController _dobCtrl;
  late DateTime date;
  late NoteTrackerController _noteTrackerController;
  late ExpenseNoteService _expNoteService;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _amountCtrl = TextEditingController();
    _noteCtrl = TextEditingController();
    _dobCtrl = TextEditingController();
    _dobCtrl.text = DateTime.now().toString().split(" ")[0];
    _noteTrackerController = NoteTrackerController();
    _expNoteService = ExpenseNoteService();

    _id = "";
    _selectedNoteType = 0;
    date = DateTime.now();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    _moneyJarCardList = Provider.of<MoneyJarProvider>(context, listen: true)
        .moneyJarList
        .map((moneyJar) => MoneyJarCard(moneyJar: moneyJar))
        .toList();

    _friendCardList = [];
  }

  void _getNoteSection(int selectedIndex) {}

  void _saveNote() {
    if (_formKey.currentState!.validate() && _id.isNotEmpty) {
      if (_selectedNoteType == 0) {
        _expNoteService.createExpenseNote(
          context: context,
          amount: double.parse(_amountCtrl.text.replaceAll(",", ".")),
          jarId: _id,
          date: date,
          note: _noteCtrl.text,
        );
      } else if (_selectedNoteType == 1) {
        // TODO: Create a loan note
      } else {
        // TODO: Create an income note
      }
      _resetForm();
    } else {
      // TODO: Craete a custom snackbar to require user to select a money jar, loaner or income source
    }
  }

  void _resetForm() {
    _amountCtrl.clear();
    _noteCtrl.clear();
    date = DateTime.now();
    _dobCtrl.text = date.toString().split(" ")[0];
  }

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
            groupValue: _selectedNoteType,
            onValueChanged: (newValue) => setState(() {
              _selectedNoteType = newValue!;
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
                      child: (_selectedNoteType == 0)
                          ? ExpenseSection(
                              sectionType: _selectedNoteType,
                              moneyJarList: _moneyJarCardList,
                              onSelected: (value) {
                                setState(() {
                                  _id = value;
                                });
                              })
                          : (_selectedNoteType == 1)
                              ? LoanSection(
                                  sectionType: _selectedNoteType,
                                  friendCardList: _friendCardList,
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
                  controller: _amountCtrl,
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
                  validator: (value) =>
                      _noteTrackerController.validateAmount(value),
                ),
                const Gap(10),
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    prefixIcon: const Icon(IconlyLight.calendar),
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
                const Gap(100),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => _saveNote(),
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
