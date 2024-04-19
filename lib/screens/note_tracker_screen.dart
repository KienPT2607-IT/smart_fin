import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/controllers/note_tracker_controller.dart';
import 'package:smart_fin/data/models/friend.dart';
import 'package:smart_fin/data/services/apis/expense_note_services.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/apis/income_note_services.dart';
import 'package:smart_fin/data/services/apis/loan_note_services.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/income_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/expense_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/loan_section.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';
import 'package:smart_fin/utilities/widgets/cards/income_source_card.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';
import 'package:smart_fin/utilities/customs/custom_date_picker.dart';

class NoteTrackerScreen extends StatefulWidget {
  const NoteTrackerScreen({super.key});

  @override
  State<NoteTrackerScreen> createState() => _NoteTrackerScreenState();
}

class _NoteTrackerScreenState extends State<NoteTrackerScreen> {
  late int _selectedSegment;

  late String _jarId;
  late String _participantId; // * Id of friend in loan-note
  late bool _isCreatorLender;
  late String _sourceId;

  late List<MoneyJarCard> _jarCardList;
  late List<IncomeSourceCard> _sourceCardList;
  late List<Friend> _friendList;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _amountCtrl;
  late TextEditingController _noteCtrl;
  late TextEditingController _dobCtrl;
  late DateTime date;
  late NoteTrackerController _noteTrackerController;
  late ExpenseNoteService _expNoteService;
  late LoanNoteService _loanNoteService;
  late IncomeNoteService _incomeNoteService;

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
    _loanNoteService = LoanNoteService();
    _incomeNoteService = IncomeNoteService();

    _jarId = "";
    _participantId = "";
    _sourceId = "";

    _selectedSegment = 0;
    date = DateTime.now();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    _jarCardList = Provider.of<MoneyJarProvider>(context)
        .moneyJarList
        .map((jar) => MoneyJarCard(moneyJar: jar))
        .toList();
    _sourceCardList = Provider.of<IncomeSourceProvider>(context)
        .incomeSourceList
        .map((source) => IncomeSourceCard(incomeSource: source))
        .toList();
    _friendList = Provider.of<FriendProvider>(context).friendList;
  }

  Widget _getNoteSection() {
    if (_selectedSegment == 0) {
      return ExpenseSection(
        sectionType: _selectedSegment,
        jarCardList: _jarCardList,
        onJarSelected: (value) => setState(() {
          _jarId = value;
        }),
      );
    } else if (_selectedSegment == 1) {
      return LoanSection(
        sectionType: _selectedSegment,
        friendList: _friendList,
        moneyJarList: _jarCardList,
        onJarSelected: (value) => setState(() {
          _jarId = value;
        }),
        onFriendSelected: (String participantId, bool isCreatorLender) {
          setState(() {
            _participantId = participantId;
            _isCreatorLender = isCreatorLender;
          });
        },
      );
    } else {
      return IncomeSection(
        sectionType: _selectedSegment,
        moneyJarCardList: _jarCardList,
        incomeCardList: _sourceCardList,
        onIncomeSourceSelected: (value) => setState(() {
          _sourceId = value;
        }),
        onMoneyJarSelected: (value) => setState(() {
          _jarId = value;
        }),
      );
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSegment == 0) {
        _saveExpenseNote();
      } else if (_selectedSegment == 1) {
        _saveLoanNote();
      } else {
        _saveIncomeNote();
      }
    }
  }

  void _saveExpenseNote() {
    if (_jarId.isNotEmpty) {
      _expNoteService.createNote(
        context: context,
        amount: double.parse(_amountCtrl.text.replaceAll(",", ".")),
        jarId: _jarId,
        date: date,
        note: _noteCtrl.text,
      );
      showCustomSnackBar(context, "Expense saved!");
      _resetForm();
    } else {
      showCustomSnackBar(context, "No money jar selected!");
    }
  }

  void _saveLoanNote() {
    int participant =
        _friendList.indexWhere((friend) => friend.id == _participantId);
    if (_jarId.isNotEmpty && participant >= 0) {
      _loanNoteService.createNote(
        context: context,
        participantId: _participantId,
        participantName: _friendList[participant].name,
        amount: double.parse(_amountCtrl.text.replaceAll(",", ".")),
        note: _noteCtrl.text,
        isCreatorLender: _isCreatorLender,
        createAt: date,
        moneyJarId: _jarId,
      );
      showCustomSnackBar(context, "Loan saved!");
      _resetForm();
    } else {
      showCustomSnackBar(context, "No lender or Money jar selected!");
    }
  }

  void _saveIncomeNote() {
    if (_jarId.isNotEmpty && _sourceId.isNotEmpty) {
      _incomeNoteService.createNote(
        context: context,
        amount: double.parse(_amountCtrl.text.replaceAll(",", ".")),
        createAt: date,
        incomeSource: _sourceId,
        moneyJar: _jarId,
        note: _noteCtrl.text,
      );
      showCustomSnackBar(context, "Income saved!");
    } else {
      showCustomSnackBar(context, "No Income Source or Money jar selected!");
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
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFD5D5D7),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: SizedBox(
                    height: 155,
                    child: _getNoteSection(),
                  ),
                ),
                const Gap(10),
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    prefixIcon: Icon(IconlyLight.wallet),
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
                  //TODO: Turn into a helper method
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
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Note",
                    prefixIcon: Icon(IconlyLight.document),
                  ),
                ),
                const Gap(20),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => _saveNote(),
                      child: const Text("Note"),
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
