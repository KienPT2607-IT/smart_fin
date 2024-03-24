import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/Income_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/expense_section.dart';
import 'package:smart_fin/screens/components/note_tracker_screen/loan_section.dart';

class NoteForm extends StatefulWidget {
  final int noteType;
  const NoteForm({super.key, required this.noteType});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _moneyAmountCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
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
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SizedBox(
                height: 143,
                // child: (widget.noteType == 0)
                //     ? const ExpenseSection()
                //     : (widget.noteType == 1)
                //         ? const LoanSection()
                //         : const IncomeSection(),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          const Text("A date picker here"),
          const SizedBox(height: 10),
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
            validator: (value) {
              return null;
            },
          ),
          const SizedBox(height: 170),
          Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
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
    );
  }
}
