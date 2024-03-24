import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_fin/controllers/account_controller.dart';
import 'package:smart_fin/screens/spending_jars_input_screen.dart';

// TODO: Turn into Screen that user update their information
class TakeUserInforScreen extends StatefulWidget {
  const TakeUserInforScreen({super.key});

  @override
  State<TakeUserInforScreen> createState() => _TakeUserInforScreenState();
}

class _TakeUserInforScreenState extends State<TakeUserInforScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _fullNameCtrl;
  late TextEditingController _phoneNumberCtrl;
  late TextEditingController _dobCtrl;

  late AccountController _accountController;
  late String _gender;
  late DateTime date;
  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController();
    _phoneNumberCtrl = TextEditingController();
    _dobCtrl = TextEditingController();

    _accountController = AccountController();
    // _getDateNow(DateTime.now());
    _gender = "Male";
    date = DateTime.now();
  }

// Todo: Set restrictions for the date of birth: From 100 years ago to now
  // void _getDateNow(DateTime date) {
  //   _dobCtrl = date.toString().split(" ")[0];
  // }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.only(top: 6.0),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void goToNext() {
    print(_dobCtrl.text);
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => const SpendingJarsInputScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Enter information",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const Gap(10),
                      Text(
                        "Step 1/2",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Gap(60),
                      TextFormField(
                        controller: _fullNameCtrl,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            _accountController.validateFullName(value),
                      ),
                      const Gap(10),
                      TextFormField(
                        controller: _phoneNumberCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: const Icon(Icons.contact_phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            _accountController.validatePhoneNumber(value),
                      ),
                      const Gap(10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _dobCtrl,
                              keyboardType: TextInputType.datetime,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                                prefixIcon:
                                    const Icon(Icons.calendar_today_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onTap: () => _showDialog(
                                CupertinoDatePicker(
                                  initialDateTime: date,
                                  mode: CupertinoDatePickerMode.date,
                                  maximumDate: DateTime.now(),
                                  minimumYear: DateTime.now().year - 100,
                                  onDateTimeChanged: (newDate) {
                                    setState(() {
                                      date = newDate;
                                      _dobCtrl.text =
                                          date.toString().split(" ")[0];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              onChanged: (newValue) {
                                setState(() {
                                  _gender = newValue!;
                                });
                              },
                              items: <String>[
                                'Male',
                                'Female',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: "Gender",
                                prefixIcon:
                                    const Icon(Icons.favorite_border_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      ElevatedButton(
                        onPressed: goToNext,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
