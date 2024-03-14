import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/user.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NoteTrackerScreen extends StatefulWidget {
  const NoteTrackerScreen({super.key});

  @override
  State<NoteTrackerScreen> createState() => _NoteTrackerScreenState();
}

class _NoteTrackerScreenState extends State<NoteTrackerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  int selectedForm = 0;

  final TextEditingController _moneyAmountCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return Center(
      child: Column(
        children: <Widget>[
          CupertinoSlidingSegmentedControl(
            children: const {
              0: Text("Expense"),
              1: Text("Debt"),
            },
            groupValue: selectedForm,
            onValueChanged: (newValue) => setState(() {
              selectedForm = newValue!;
            }),
          ),
          const SizedBox(height: 10),
          Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  const Column(
                    children: <Widget>[
                      Row(), // TODO: Implement: From + avatar + view all (Spending jars)
                      Row(), // TODO: Implement: Horizontally scrollable list of spending jars,
                    ],
                  ),
                  TextFormField(
                    controller: _moneyAmountCtrl,
                    keyboardType: TextInputType.number,
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
                  TextFormField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(
                      labelText: "Note",
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
            ),
          ),
        ],
      ),
    );
  }
}
